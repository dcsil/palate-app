"""
Firebase service for managing restaurant data (ADC-friendly, lazy init)
"""
from typing import Dict, Any, Optional, List
from datetime import datetime
import os
import json

import firebase_admin
from firebase_admin import credentials, firestore


class FirebaseService:
    """Service class for Firebase operations"""

    def __init__(self):
        self.db: Optional[firestore.Client] = None
        self._initialize_firebase()

    def _initialize_firebase(self):
        """
        Initialize Firebase Admin SDK using:
        - Firestore emulator if FIRESTORE_EMULATOR_HOST is set (no creds)
        - Application Default Credentials (ADC) on Cloud Run / local gcloud ADC
        - Optional JSON from env var FIREBASE_SERVICE_ACCOUNT_JSON (no file)
        """
        if not firebase_admin._apps:
            project_id = os.getenv("GOOGLE_CLOUD_PROJECT")

            # Emulator path: no creds required
            if os.getenv("FIRESTORE_EMULATOR_HOST"):
                firebase_admin.initialize_app(options={"projectId": project_id})
            else:
                try:
                    # Primary: ADC (Cloud Run SA / gcloud ADC)
                    cred = credentials.ApplicationDefault()
                    # Passing projectId helps when ADC project is implicit
                    firebase_admin.initialize_app(cred, {"projectId": project_id})
                except Exception as adc_err:
                    # Fallback: service account JSON via env var (still no file)
                    sa_json = os.getenv("FIREBASE_SERVICE_ACCOUNT_JSON")
                    if sa_json:
                        cred = credentials.Certificate(json.loads(sa_json))
                        firebase_admin.initialize_app(cred, {"projectId": project_id})
                    else:
                        raise RuntimeError(
                            "Firebase init failed: no ADC and no FIREBASE_SERVICE_ACCOUNT_JSON. "
                            "On Cloud Run, attach a service account. For local, run "
                            "`gcloud auth application-default login` and pass GOOGLE_CLOUD_PROJECT."
                        ) from adc_err

        # Create Firestore client
        self.db = firestore.client()

    def _flatten_search_result(self, search_result: Dict[str, Any]) -> Dict[str, Any]:
        """
        Flatten the nested search result into Firebase-friendly structure
        """
        print(f"DEBUG: _flatten_search_result called with type: {type(search_result)}")
        print(f"DEBUG: search_result is None: {search_result is None}")
        
        # Handle None search_result - don't update anything if no search data
        if search_result is None:
            print("DEBUG: search_result is None, returning empty dict")
            return {}
        
        try:
            # Debug each section to find the exact issue
            print("DEBUG: Processing basic info...")
            basic_info = {
                "place_id": search_result.get("place_id"),
                "name": search_result.get("name"),
                "distance_meters": search_result.get("distance_meters"),
            }
            
            print("DEBUG: Processing images...")
            images = {
                "images": search_result.get("photos", []),
            }
            
            print("DEBUG: Processing hours...")
            hours_data = search_result.get("hours", {})
            current_hours = hours_data.get("current") if hours_data else None
            hours = {
                "open_now": current_hours.get("openNow") if current_hours else None,
                "current_hours": current_hours,
                "current_secondary_hours": hours_data.get("current_secondary") if hours_data else None,
            }
            
            print("DEBUG: Processing service options...")
            service_options = search_result.get("service_options", {})
            print(f"DEBUG: service_options type: {type(service_options)}")
            serves = service_options.get("serves", {}) if service_options else {}
            print(f"DEBUG: serves type: {type(serves)}")
            
            service_fields = {
                "takeout": service_options.get("takeout") if service_options else None,
                "delivery": service_options.get("delivery") if service_options else None,
                "dine_in": service_options.get("dine_in") if service_options else None,
                "curbside_pickup": service_options.get("curbside_pickup") if service_options else None,
                "reservable": service_options.get("reservable") if service_options else None,
                "serves_breakfast": serves.get("breakfast") if serves else None,
                "serves_lunch": serves.get("lunch") if serves else None,
                "serves_dinner": serves.get("dinner") if serves else None,
                "serves_beer": serves.get("beer") if serves else None,
                "serves_wine": serves.get("wine") if serves else None,
                "serves_cocktails": serves.get("cocktails") if serves else None,
                "serves_vegetarian": serves.get("vegetarian_food") if serves else None,
            }
            
            print("DEBUG: Processing ambience...")
            ambience = search_result.get("ambience", {})
            print(f"DEBUG: ambience type: {type(ambience)}")
            
            ambience_fields = {
                "outdoor_seating": ambience.get("outdoor_seating") if ambience else None,
                "live_music": ambience.get("live_music") if ambience else None,
                "good_for_groups": ambience.get("good_for_groups") if ambience else None,
                "good_for_children": ambience.get("good_for_children") if ambience else None,
                "good_for_watching_sports": ambience.get("good_for_watching_sports") if ambience else None,
                "allows_dogs": ambience.get("allows_dogs") if ambience else None,
                "has_restroom": ambience.get("restroom") if ambience else None,
            }
            
            print("DEBUG: Processing other amenities...")
            other_amenities = {
                "accessibility_options": search_result.get("accessibility_options") or {},
                "payment_options": search_result.get("payment_options") or {},
                "parking_options": search_result.get("parking_options") or {},
            }
            
            print("DEBUG: Processing summaries...")
            summaries = {
                "editorial_summary": search_result.get("editorial_summary"),
                "generative_overview": search_result.get("generative_summary", {}).get("overview"),
                "generative_description": search_result.get("generative_summary", {}).get("description"),
                "review_summary": search_result.get("review_summary"),
            }
            
            print("DEBUG: Processing basic info 2...")
            basic_info2 = {
                "rating": search_result.get("rating"),
                "user_rating_count": search_result.get("user_rating_count"),
                "price_level": search_result.get("price_level"),
                "primary_type": search_result.get("primary_type"),
                "types": search_result.get("types", []),
                "maps_links": search_result.get("maps_links"),
            }
            
            print("DEBUG: Processing timestamps...")
            timestamps = {
                "last_updated": datetime.utcnow(),
                "search_timestamp": datetime.utcnow().isoformat(),
            }
            
            print("DEBUG: Combining all fields...")
            flattened = {
                **basic_info,
                **images,
                **hours,
                **service_fields,
                **ambience_fields,
                **other_amenities,
                **summaries,
                **basic_info2,
                **timestamps,
            }
        except Exception as e:
            print(f"DEBUG: Error in _flatten_search_result: {str(e)}")
            print(f"DEBUG: search_result keys: {list(search_result.keys()) if search_result else 'None'}")
            print(f"DEBUG: search_result: {search_result}")
            raise e

        return {k: v for k, v in flattened.items() if v is not None}

    def _create_new_restaurant_data(self, place_id: str, search_result: Dict[str, Any]) -> Dict[str, Any]:
        """
        Create new restaurant data structure based on search_result and example format
        """
        try:
            # Extract basic information from search_result
            name = search_result.get("name", "Unknown Restaurant")
            latitude = search_result.get("latitude")
            longitude = search_result.get("longitude")
            formatted_address = search_result.get("formatted_address", "")
            
            # Extract types/category information
            types = search_result.get("types", [])
            category = "Restaurant"  # Default category
            if types:
                # Try to find a restaurant-specific type
                restaurant_types = [t for t in types if "restaurant" in t.lower()]
                if restaurant_types:
                    category = restaurant_types[0].replace("_", " ").title()
                else:
                    # Use the first type as category
                    category = types[0].replace("_", " ").title()
            
            # Create the new restaurant data structure
            new_restaurant = {
                "google_place_id": place_id,
                "name": name,
                "latitude": latitude,
                "longitude": longitude,
                "formatted_address": formatted_address,
                "category": category,
                "google_types": types,
                "created_at": datetime.utcnow().strftime("%d %B %Y at %H:%M:%S UTC-4"),
                
                # Add flattened search result data if available
                **self._flatten_search_result(search_result)
            }
            
            # Only return data if we have valid coordinates
            if latitude is not None and longitude is not None:
                return new_restaurant
            else:
                print(f"Cannot create restaurant without valid coordinates for place_id: {place_id}")
                return {}
                
        except Exception as e:
            print(f"Error creating new restaurant data: {str(e)}")
            return {}

    async def get_nearby_restaurants(self, user_lat: float, user_lng: float, limit: int = 20) -> List[Dict[str, Any]]:
        """
        Get nearby restaurants from Firestore and calculate distances
        """
        try:
            print(f"Firebase: Getting nearby restaurants for lat={user_lat}, lng={user_lng}, limit={limit}")
            restaurants_ref = self.db.collection("restaurants")
            # Get all restaurants (we'll calculate distance in Python for now)
            # In production, you might want to use GeoFirestore or similar for better performance
            docs = restaurants_ref.limit(limit * 2).get()  # Get more than needed to account for filtering
            
            restaurants = []
            for doc in docs:
                data = doc.to_dict()
                if not data:
                    continue
                    
                # Get restaurant coordinates
                restaurant_lat = data.get("latitude")
                restaurant_lng = data.get("longitude")
                
                if restaurant_lat is None or restaurant_lng is None:
                    continue
                
                # Calculate distance
                from utils import haversine_meters
                distance = haversine_meters(user_lat, user_lng, restaurant_lat, restaurant_lng)
                
                restaurant_data = {
                    "doc_id": doc.id,
                    "place_id": data.get("google_place_id"),
                    "name": data.get("name"),
                    "latitude": restaurant_lat,
                    "longitude": restaurant_lng,
                    "distance_meters": distance,
                    "has_search_timestamp": "search_timestamp" in data,
                    "search_timestamp": data.get("search_timestamp")
                }
                restaurants.append(restaurant_data)
            
            # Sort by distance and return top N
            restaurants.sort(key=lambda x: x["distance_meters"])
            result = restaurants[:limit]
            print(f"Firebase: Returning {len(result)} restaurants")
            return result
            
        except Exception as e:
            print(f"Error getting nearby restaurants: {str(e)}")
            import traceback
            traceback.print_exc()
            return []

    async def update_restaurant_search_result(self, place_id: str, search_result: Dict[str, Any]) -> bool:
        """
        Find restaurant by google_place_id and update with flattened search_result.
        If restaurant not found, create a new one with basic information.
        """
        try:
            restaurants_ref = self.db.collection("restaurants")
            query = restaurants_ref.where("google_place_id", "==", place_id).limit(1)
            docs = query.get()

            if not docs:
                print(f"No restaurant found with google_place_id: {place_id}, creating new one")
                
                # Check if we have valid search_result data
                if search_result is None:
                    print(f"Cannot create restaurant: search_result is None for place_id: {place_id}")
                    return False
                
                # Create new restaurant with basic information from search_result
                new_restaurant_data = self._create_new_restaurant_data(place_id, search_result)
                
                if new_restaurant_data:
                    # Add the new restaurant to Firestore
                    doc_ref = restaurants_ref.add(new_restaurant_data)
                    print(f"Successfully created new restaurant with google_place_id: {place_id}")
                    return True
                else:
                    print(f"No valid data to create restaurant for place_id: {place_id}")
                    return False

            doc = docs[0]
            doc_ref = restaurants_ref.document(doc.id)

            flattened_result = self._flatten_search_result(search_result)
            
            # Only update if we have actual data to update
            if flattened_result:
                doc_ref.update(flattened_result)
                print(f"Successfully updated restaurant {doc.id} with flattened search result for place_id: {place_id}")
                return True
            else:
                print(f"No data to update for restaurant {doc.id} with place_id: {place_id}")
                return False

        except Exception as e:
            print(f"Error updating restaurant search result: {str(e)}")
            return False

    async def get_restaurants_by_place_ids(self, place_ids: List[str]) -> Dict[str, Dict[str, Any]]:
        """
        Get restaurants from Firebase by their place_ids
        
        Args:
            place_ids: List of Google Place IDs to look up
        
        Returns:
            Dictionary mapping place_id to restaurant data
        """
        try:
            print(f"Firebase: Looking up {len(place_ids)} restaurants by place_id")
            print(f"Firebase: Searching for place_ids: {place_ids}")
            restaurants_ref = self.db.collection("restaurants")
            
            # Query restaurants where google_place_id is in the list
            query = restaurants_ref.where("google_place_id", "in", place_ids)
            docs = query.get()
            
            print(f"Firebase: Query returned {len(list(docs))} documents")
            
            # Convert to list since we need to iterate multiple times
            docs_list = list(docs)
            print(f"Firebase: Processing {len(docs_list)} documents")
            
            result = {}
            for doc in docs_list:
                data = doc.to_dict()
                print(f"Firebase: Document {doc.id} has data keys: {list(data.keys()) if data else 'None'}")
                print(f"Firebase: Document {doc.id} google_place_id: {data.get('google_place_id') if data else 'None'}")
                print(f"Firebase: Document {doc.id} place_id: {data.get('place_id') if data else 'None'}")
                
                if data and data.get("google_place_id"):
                    result[data["google_place_id"]] = {
                        "doc_id": doc.id,
                        "name": data.get("name"),
                        "latitude": data.get("latitude"),
                        "longitude": data.get("longitude"),
                        "place_id": data.get("google_place_id"),  # Map google_place_id to place_id for consistency
                        "has_search_timestamp": "search_timestamp" in data,
                        **data  # Include all other fields
                    }
                    print(f"Firebase: Added {data['google_place_id']} to result")
                else:
                    print(f"Firebase: Skipping document {doc.id} - no google_place_id")
            
            print(f"Firebase: Found {len(result)} restaurants in database")
            print(f"Firebase: Result keys: {list(result.keys())}")
            return result
            
        except Exception as e:
            print(f"Error getting restaurants by place_ids: {str(e)}")
            return {}

    async def delete_restaurant_by_place_id(self, place_id: str) -> bool:
        """
        Delete restaurant from Firebase by google_place_id
        
        Args:
            place_id: Google Place ID to delete
        
        Returns:
            True if deleted successfully, False otherwise
        """
        try:
            print(f"Firebase: Deleting restaurant with google_place_id: {place_id}")
            restaurants_ref = self.db.collection("restaurants")
            
            # Find restaurant by google_place_id
            query = restaurants_ref.where("google_place_id", "==", place_id).limit(1)
            docs = query.get()
            
            if not docs:
                print(f"No restaurant found with google_place_id: {place_id}")
                return False
            
            # Delete the restaurant
            doc = docs[0]
            doc_ref = restaurants_ref.document(doc.id)
            doc_ref.delete()
            
            print(f"Successfully deleted restaurant {doc.id} with google_place_id: {place_id}")
            return True
            
        except Exception as e:
            print(f"Error deleting restaurant by place_id: {str(e)}")
            return False


# Lazy singleton accessor (avoid init at import time)
_firebase_service_singleton: Optional[FirebaseService] = None

def get_firebase_service() -> FirebaseService:
    global _firebase_service_singleton
    if _firebase_service_singleton is None:
        _firebase_service_singleton = FirebaseService()
    return _firebase_service_singleton
