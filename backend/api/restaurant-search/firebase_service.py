"""
Minimal Firebase service with GeoPoint + geohash pattern for fast radius search
"""
import os
import json
import asyncio
import firebase_admin
from firebase_admin import credentials, firestore
from google.cloud.firestore import GeoPoint, FieldFilter
from typing import List, Dict, Any, Optional
import math
from datetime import datetime, timedelta


class FirebaseService:
    def __init__(self):
        self.db = None
        self._init_firebase()

    def _init_firebase(self):
        if not firebase_admin._apps:
            project_id = os.getenv("GOOGLE_CLOUD_PROJECT")

            if os.getenv("FIRESTORE_EMULATOR_HOST"):
                firebase_admin.initialize_app(options={"projectId": project_id})
            else:
                try:
                    # Use Application Default Credentials (ADC) - recommended for Cloud Run
                    cred = credentials.ApplicationDefault()
                    firebase_admin.initialize_app(cred, {"projectId": project_id})
                    print("Firebase initialized with Application Default Credentials")
                except Exception as e:
                    # Fallback to environment variable for local development
                    sa_json = os.getenv("FIREBASE_SERVICE_ACCOUNT_JSON")
                    if sa_json:
                        print("Using Firebase service account from environment variable")
                        cred = credentials.Certificate(json.loads(sa_json))
                        firebase_admin.initialize_app(cred, {"projectId": project_id})
                    else:
                        raise RuntimeError(f"Firebase initialization failed with ADC: {e}. For local development, set FIREBASE_SERVICE_ACCOUNT_JSON environment variable.")
        
        self.db = firestore.client()

    def _calculate_bounding_box(self, lat: float, lng: float, radius_km: float) -> Dict[str, float]:
        """Calculate bounding box for geohash filtering"""
        radius_m = radius_km * 1000
        earth_radius = 6371000
        
        lat_delta = radius_m / earth_radius * (180 / math.pi)
        lng_delta = radius_m / (earth_radius * math.cos(math.radians(lat))) * (180 / math.pi)
        
        return {
            "min_lat": lat - lat_delta,
            "max_lat": lat + lat_delta,
            "min_lng": lng - lng_delta,
            "max_lng": lng + lng_delta
        }

    def _haversine_distance(self, lat1: float, lng1: float, lat2: float, lng2: float) -> float:
        """Calculate distance between two points in kilometers"""
        R = 6371  # Earth's radius in km
        
        dlat = math.radians(lat2 - lat1)
        dlng = math.radians(lng2 - lng1)
        
        a = (math.sin(dlat/2) * math.sin(dlat/2) + 
             math.cos(math.radians(lat1)) * math.cos(math.radians(lat2)) * 
             math.sin(dlng/2) * math.sin(dlng/2))
        
        return 2 * R * math.asin(math.sqrt(a))

    async def search_restaurants(self, center_lat: float, center_lng: float, radius_km: float) -> List[Dict[str, Any]]:
        """Search restaurants within radius using GeoPoint + geohash pattern"""
        try:
            # Calculate bounding box for initial filtering
            bbox = self._calculate_bounding_box(center_lat, center_lng, radius_km)
            
            # Query restaurants with location field (GeoPoint)
            restaurants_ref = self.db.collection("restaurants")
            
            # Use compound query for bounding box filtering
            query = (restaurants_ref
                    .where(filter=FieldFilter("location", ">=", GeoPoint(bbox["min_lat"], bbox["min_lng"])))
                    .where(filter=FieldFilter("location", "<=", GeoPoint(bbox["max_lat"], bbox["max_lng"]))))
            
            import asyncio
            docs = await asyncio.to_thread(query.get)
            
            # Post-filter with accurate Haversine distance
            results = []
            for doc in docs:
                data = doc.to_dict()
                if not data or "location" not in data:
                    continue
                
                location = data["location"]
                distance_km = self._haversine_distance(
                    center_lat, center_lng,
                    location.latitude, location.longitude
                )
                
                if distance_km <= radius_km:
                    results.append({
                    "doc_id": doc.id,
                    "place_id": data.get("place_id"),
                        "name": data.get("name", "Unknown"),
                        "location": location,  # GeoPoint object
                        "distance_km": round(distance_km, 2)
                    })
            
            # Sort by distance
            results.sort(key=lambda x: x["distance_km"])
            return results
            
        except Exception as e:
            print(f"Error searching restaurants: {e}")
            return []

    async def get_restaurant_by_place_id(self, place_id: str) -> Optional[Dict[str, Any]]:
        """Get restaurant document by place_id"""
        try:
            restaurants_ref = self.db.collection("restaurants")
            query = restaurants_ref.where(filter=FieldFilter("place_id", "==", place_id)).limit(1)
            # Use asyncio.to_thread to run the synchronous Firestore operation in a thread pool
            import asyncio
            docs = await asyncio.to_thread(query.get)
            
            if docs:
                doc = docs[0]
                data = doc.to_dict()
                data["doc_id"] = doc.id
                return data
            return None
        except Exception as e:
            print(f"Error getting restaurant by place_id: {e}")
            return None

    async def is_restaurant_details_stale(self, place_id: str, days_threshold: int = 7) -> bool:
        """Check if restaurant details are older than the threshold"""
        try:
            restaurant = await self.get_restaurant_by_place_id(place_id)
            if not restaurant:
                return True  # If restaurant doesn't exist, consider it stale
            
            search_timestamp = restaurant.get("search_timestamp")
            if not search_timestamp:
                return True  # If no timestamp, consider it stale
            
            print(f"DEBUG: search_timestamp type: {type(search_timestamp)}, value: {search_timestamp}")
            
            # Convert Firestore timestamp to datetime
            if hasattr(search_timestamp, 'timestamp'):
                # Firestore timestamp object
                last_updated = datetime.fromtimestamp(search_timestamp.timestamp())
            elif isinstance(search_timestamp, str):
                # String timestamp - try to parse it
                try:
                    last_updated = datetime.fromisoformat(search_timestamp.replace('Z', '+00:00'))
                except ValueError:
                    # If parsing fails, consider it stale
                    return True
            elif isinstance(search_timestamp, datetime):
                # Already a datetime object
                last_updated = search_timestamp
            else:
                # Unknown type, consider it stale
                return True
            
            # Check if it's older than the threshold
            threshold_date = datetime.now() - timedelta(days=days_threshold)
            return last_updated < threshold_date
            
        except Exception as e:
            print(f"Error checking if restaurant details are stale: {e}")
            return True  # If error, consider it stale

    async def get_restaurant_details_from_firebase(self, place_id: str) -> Optional[Dict[str, Any]]:
        """Get restaurant details from Firebase if they exist and are fresh"""
        try:
            restaurant = await self.get_restaurant_by_place_id(place_id)
            if not restaurant:
                return None
            
            # Check if details are stale
            is_stale = await self.is_restaurant_details_stale(place_id, days_threshold=7)
            if is_stale:
                return None  # Data is stale, need to fetch fresh data
            
            # Return the restaurant details (excluding internal fields)
            details = {}
            exclude_fields = {'doc_id', 'place_id', 'location', 'search_timestamp', 'last_updated'}
            
            for key, value in restaurant.items():
                if key not in exclude_fields and value is not None:
                    details[key] = value
            
            return details if details else None
            
        except Exception as e:
            print(f"Error getting restaurant details from Firebase: {e}")
            return None

    async def update_restaurant_details(self, place_id: str, details: Dict[str, Any]) -> bool:
        """Update restaurant details in Firebase"""
        try:
            restaurant = await self.get_restaurant_by_place_id(place_id)
            if not restaurant:
                print(f"Restaurant with place_id {place_id} not found in Firebase")
                return False
            
            doc_id = restaurant["doc_id"]
            restaurants_ref = self.db.collection("restaurants")
            
            # Prepare update data
            update_data = {
                "search_timestamp": datetime.now(),
                "last_updated": datetime.now()
            }
            
            # Add all the details fields
            for key, value in details.items():
                if value is not None:  # Only update non-null values
                    update_data[key] = value
            
            # Update the document
            import asyncio
            await asyncio.to_thread(restaurants_ref.document(doc_id).update, update_data)
            print(f"Successfully updated restaurant details for place_id: {place_id}")
            return True
            
        except Exception as e:
            print(f"Error updating restaurant details: {e}")
            return False

    async def add_restaurant(self, restaurant_data: Dict[str, Any]) -> bool:
        """Add a restaurant to Firebase with simplified data structure"""
        try:
            restaurants_ref = self.db.collection('restaurants')
            
            # Convert location to GeoPoint
            if 'location' in restaurant_data:
                lat = restaurant_data['location'].get('latitude', 0.0)
                lng = restaurant_data['location'].get('longitude', 0.0)
                restaurant_data['location'] = GeoPoint(lat, lng)
            
            # Add the restaurant document
            doc_ref = restaurants_ref.document()
            await asyncio.to_thread(doc_ref.set, restaurant_data)
            
            return True
            
        except Exception as e:
            print(f"Error adding restaurant to Firebase: {e}")
            return False

    async def delete_restaurant_by_place_id(self, place_id: str) -> bool:
        """Delete a restaurant from Firebase by place_id"""
        try:
            # First, find the restaurant document by place_id
            restaurant = await self.get_restaurant_by_place_id(place_id)
            if not restaurant:
                print(f"Restaurant with place_id {place_id} not found in Firebase")
                return False
            
            doc_id = restaurant["doc_id"]
            restaurants_ref = self.db.collection("restaurants")
            
            # Delete the document
            await asyncio.to_thread(restaurants_ref.document(doc_id).delete)
            print(f"Successfully deleted restaurant with place_id: {place_id}")
            return True
            
        except Exception as e:
            print(f"Error deleting restaurant by place_id {place_id}: {e}")
            return False


# Singleton instance
_firebase_service = None

def get_firebase_service() -> FirebaseService:
    global _firebase_service
    if _firebase_service is None:
        _firebase_service = FirebaseService()
    return _firebase_service