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
        # Handle None search_result - don't update anything if no search data
        if search_result is None:
            return {}
        
        flattened = {
            # Basic info
            "place_id": search_result.get("place_id"),
            "name": search_result.get("name"),
            "distance_meters": search_result.get("distance_meters"),

            # Images (renamed from photos)
            "images": search_result.get("photos", []),

            # Hours - flatten current hours
            "open_now": search_result.get("hours", {}).get("current", {}).get("openNow"),
            "current_hours": search_result.get("hours", {}).get("current"),
            "current_secondary_hours": search_result.get("hours", {}).get("current_secondary"),

            # Service options - flatten into individual fields
            "takeout": search_result.get("service_options", {}).get("takeout"),
            "delivery": search_result.get("service_options", {}).get("delivery"),
            "dine_in": search_result.get("service_options", {}).get("dine_in"),
            "curbside_pickup": search_result.get("service_options", {}).get("curbside_pickup"),
            "reservable": search_result.get("service_options", {}).get("reservable"),

            # What they serve
            "serves_breakfast": search_result.get("service_options", {}).get("serves", {}).get("breakfast"),
            "serves_lunch": search_result.get("service_options", {}).get("serves", {}).get("lunch"),
            "serves_dinner": search_result.get("service_options", {}).get("serves", {}).get("dinner"),
            "serves_beer": search_result.get("service_options", {}).get("serves", {}).get("beer"),
            "serves_wine": search_result.get("service_options", {}).get("serves", {}).get("wine"),
            "serves_cocktails": search_result.get("service_options", {}).get("serves", {}).get("cocktails"),
            "serves_vegetarian": search_result.get("service_options", {}).get("serves", {}).get("vegetarian_food"),

            # Ambience
            "outdoor_seating": search_result.get("ambience", {}).get("outdoor_seating"),
            "live_music": search_result.get("ambience", {}).get("live_music"),
            "good_for_groups": search_result.get("ambience", {}).get("good_for_groups"),
            "good_for_children": search_result.get("ambience", {}).get("good_for_children"),
            "good_for_watching_sports": search_result.get("ambience", {}).get("good_for_watching_sports"),
            "allows_dogs": search_result.get("ambience", {}).get("allows_dogs"),
            "has_restroom": search_result.get("ambience", {}).get("restroom"),

            # Other amenities
            "accessibility_options": search_result.get("accessibility_options"),
            "payment_options": search_result.get("payment_options"),
            "parking_options": search_result.get("parking_options"),

            # Summaries
            "editorial_summary": search_result.get("editorial_summary"),
            "generative_overview": search_result.get("generative_summary", {}).get("overview"),
            "generative_description": search_result.get("generative_summary", {}).get("description"),
            "review_summary": search_result.get("review_summary"),

            # Basic info
            "rating": search_result.get("rating"),
            "user_rating_count": search_result.get("user_rating_count"),
            "price_level": search_result.get("price_level"),
            "primary_type": search_result.get("primary_type"),
            "types": search_result.get("types", []),
            "maps_links": search_result.get("maps_links"),

            # Timestamps
            "last_updated": datetime.utcnow(),
            "search_timestamp": datetime.utcnow().isoformat(),
        }

        return {k: v for k, v in flattened.items() if v is not None}

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
        Find restaurant by google_place_id and update with flattened search_result
        """
        try:
            restaurants_ref = self.db.collection("restaurants")
            query = restaurants_ref.where("google_place_id", "==", place_id).limit(1)
            docs = query.get()

            if not docs:
                print(f"No restaurant found with google_place_id: {place_id}")
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


# Lazy singleton accessor (avoid init at import time)
_firebase_service_singleton: Optional[FirebaseService] = None

def get_firebase_service() -> FirebaseService:
    global _firebase_service_singleton
    if _firebase_service_singleton is None:
        _firebase_service_singleton = FirebaseService()
    return _firebase_service_singleton
