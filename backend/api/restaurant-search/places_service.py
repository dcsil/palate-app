"""
Google Places API service
"""
from typing import List, Dict, Any
import httpx
import os
from utils import haversine_meters
from dotenv import load_dotenv
load_dotenv()

class PlacesService:
    """Service class for Google Places API operations"""
    
    def __init__(self):
        self.api_key = os.getenv("GOOGLE_MAPS_API_KEY")
        self.base_url = "https://places.googleapis.com/v1"
    
    def _get_required_fields(self) -> str:
        """Get the required fields for the Places API request"""
        return ",".join([
            # Core fields
            "id",
            "displayName",
            "location",
            "photos.name",
            "photos.heightPx",
            "photos.widthPx",
            "currentOpeningHours.openNow",

            # Hours
            "regularOpeningHours",
            "currentOpeningHours",
            "regularSecondaryOpeningHours",
            "currentSecondaryOpeningHours",

            # Service options
            "takeout",
            "delivery",
            "dineIn",
            "curbsidePickup",
            "reservable",
            "servesBreakfast",
            "servesLunch",
            "servesDinner",
            "servesBeer",
            "servesWine",
            "servesCocktails",
            "servesVegetarianFood",

            # Ambience & amenities
            "outdoorSeating",
            "liveMusic",
            "goodForGroups",
            "goodForChildren",
            "goodForWatchingSports",
            "allowsDogs",
            "restroom",
            "accessibilityOptions",
            "paymentOptions",
            "parkingOptions",

            # Summaries
            "editorialSummary",
            "generativeSummary.overview",
            "generativeSummary.description",
            "reviewSummary",

            # Basic info
            "rating",
            "userRatingCount",
            "priceLevel",
            "primaryType",
            "types",
            "googleMapsLinks",
        ])
    
    async def _get_place_details(self, place_id: str) -> Dict[str, Any]:
        """Get place details from Google Places API"""
        print(f"DEBUG: _get_place_details called for place_id: {place_id}")
        fields = self._get_required_fields()
        headers = {
            "X-Goog-Api-Key": self.api_key,
            "X-Goog-FieldMask": fields,
        }
        
        details_url = f"{self.base_url}/places/{place_id}"
        print(f"DEBUG: Making API call to: {details_url}")
        print(f"DEBUG: Headers: {headers}")
        
        async with httpx.AsyncClient(timeout=15) as client:
            response = await client.get(details_url, headers=headers)
            print(f"DEBUG: API response status: {response.status_code}")
            print(f"DEBUG: API response headers: {dict(response.headers)}")
            
            if response.status_code != 200:
                error_text = response.text
                print(f"DEBUG: API error response: {error_text}")
                raise Exception(f"Places API error: {response.status_code} - {error_text}")
            
            json_response = response.json()
            print(f"DEBUG: API response type: {type(json_response)}")
            print(f"DEBUG: API response keys: {list(json_response.keys()) if isinstance(json_response, dict) else 'Not a dict'}")
            print(f"DEBUG: API response: {json_response}")
            return json_response
    
    async def _get_photo_urls(self, place: Dict[str, Any], min_photo_height: int, max_photos: int) -> List[str]:
        """Get photo URLs for a place"""
        raw_photos = place.get("photos", []) or []
        use_photos = [
            p for p in raw_photos
            if (p.get("heightPx") or 0) >= min_photo_height
        ][:max_photos]

        photo_urls: List[str] = []
        async with httpx.AsyncClient(timeout=15) as client:
            for p in use_photos:
                name = p.get("name")
                if not name:
                    continue
                
                media_url = f"{self.base_url}/{name}/media"
                media_params = {
                    "maxHeightPx": max(min_photo_height, 800),
                    "skipHttpRedirect": "true",
                }
                
                response = await client.get(
                    media_url, 
                    headers={"X-Goog-Api-Key": self.api_key}, 
                    params=media_params
                )
                
                if response.status_code == 200:
                    photo_uri = response.json().get("photoUri")
                    if photo_uri:
                        photo_urls.append(photo_uri)
        
        return photo_urls
    
    def _calculate_distance(self, place: Dict[str, Any], user_lat: float, user_lng: float) -> float:
        """Calculate distance between user location and place"""
        loc = place.get("location") or {}
        place_lat = loc.get("latitude")
        place_lng = loc.get("longitude")
        
        if place_lat is not None and place_lng is not None:
            return round(haversine_meters(user_lat, user_lng, place_lat, place_lng), 2)
        return None
    
    def _convert_price_level(self, price_level):
        """Convert Google Places API price level string to integer"""
        if price_level is None:
            return None
        if isinstance(price_level, int):
            return price_level
        if isinstance(price_level, str):
            price_mapping = {
                'PRICE_LEVEL_FREE': 0,
                'PRICE_LEVEL_INEXPENSIVE': 1,
                'PRICE_LEVEL_MODERATE': 2,
                'PRICE_LEVEL_EXPENSIVE': 3,
                'PRICE_LEVEL_VERY_EXPENSIVE': 4
            }
            return price_mapping.get(price_level, None)
        return None
    
    def _build_search_result(self, place: Dict[str, Any], photo_urls: List[str], distance_m: float) -> Dict[str, Any]:
        """Build the final search result dictionary"""
        print(f"DEBUG: _build_search_result called with place type: {type(place)}")
        print(f"DEBUG: place is None: {place is None}")
        if place:
            print(f"DEBUG: place keys: {list(place.keys())}")
            print(f"DEBUG: place id: {place.get('id')}")
            print(f"DEBUG: place displayName: {place.get('displayName')}")
        
        print(f"DEBUG: photo_urls type: {type(photo_urls)}, length: {len(photo_urls) if photo_urls else 'None'}")
        print(f"DEBUG: distance_m: {distance_m}")
        
        result = {
            "place_id": place.get("id"),
            "name": (place.get("displayName") or {}).get("text"),
            "photos": photo_urls,
            "distance_meters": distance_m,

            # Hours
            "hours": {
                "current": place.get("currentOpeningHours"),
                "current_secondary": place.get("currentSecondaryOpeningHours"),
            },

            # Service options
            "service_options": {
                "takeout": place.get("takeout"),
                "delivery": place.get("delivery"),
                "dine_in": place.get("dineIn"),
                "curbside_pickup": place.get("curbsidePickup"),
                "reservable": place.get("reservable"),
                "serves": {
                    "breakfast": place.get("servesBreakfast"),
                    "lunch": place.get("servesLunch"),
                    "dinner": place.get("servesDinner"),
                    "beer": place.get("servesBeer"),
                    "wine": place.get("servesWine"),
                    "cocktails": place.get("servesCocktails"),
                    "vegetarian_food": place.get("servesVegetarianFood"),
                },
            },

            # Ambience & amenities
            "ambience": {
                "outdoor_seating": place.get("outdoorSeating"),
                "live_music": place.get("liveMusic"),
                "good_for_groups": place.get("goodForGroups"),
                "good_for_children": place.get("goodForChildren"),
                "good_for_watching_sports": place.get("goodForWatchingSports"),
                "allows_dogs": place.get("allowsDogs"),
                "restroom": place.get("restroom"),
            },
            "accessibility_options": place.get("accessibilityOptions"),
            "payment_options": place.get("paymentOptions"),
            "parking_options": place.get("parkingOptions"),

            # Summaries
            "editorial_summary": (place.get("editorialSummary") or {}).get("overview"),
            "generative_summary": {
                "overview": (place.get("generativeSummary") or {}).get("overview"),
                "description": (place.get("generativeSummary") or {}).get("description"),
            },
            "review_summary": place.get("reviewSummary"),

            # Basic info
            "rating": place.get("rating"),
            "user_rating_count": place.get("userRatingCount"),
            "price_level": self._convert_price_level(place.get("priceLevel")),
            "primary_type": place.get("primaryType"),
            "types": place.get("types"),
            "maps_links": place.get("googleMapsLinks"),
        }
        
        print(f"DEBUG: Built result with place_id: {result.get('place_id')}")
        print(f"DEBUG: Built result with name: {result.get('name')}")
        print(f"DEBUG: Result keys: {list(result.keys())}")
        return result
    
    async def search_nearby_restaurants(self, user_lat: float, user_lng: float, 
                                      radius_meters: int = 5000) -> List[Dict[str, Any]]:
        """
        Search for nearby restaurants using Google Places API and filter by those in our database.
        Returns ALL restaurants within the radius, sorted by distance.
        
        Args:
            user_lat: User's latitude
            user_lng: User's longitude
            radius_meters: Search radius in meters (max 50000)
        
        Returns:
            List of restaurant place_ids and basic info, sorted by distance
        """
        # This function now uses Firebase for comprehensive coverage
        # Import Firebase service here to avoid circular imports
        from firebase_service import get_firebase_service
        
        firebase_service = get_firebase_service()
        
        # Get ALL restaurants from Firebase within the radius
        all_restaurants = await firebase_service.get_nearby_restaurants(
            user_lat=user_lat,
            user_lng=user_lng,
            limit=10000  # Large limit to get all restaurants
        )
        
        # Filter by radius
        restaurants_within_radius = [
            r for r in all_restaurants 
            if r.get("distance_meters", float('inf')) <= radius_meters
        ]
        
        # Sort by distance
        restaurants_within_radius.sort(key=lambda x: x.get("distance_meters", float('inf')))
        
        # Return simplified data for frontend pagination
        results = []
        for restaurant in restaurants_within_radius:
            results.append({
                "place_id": restaurant.get("place_id"),
                "name": restaurant.get("name"),
                "latitude": restaurant.get("latitude"),
                "longitude": restaurant.get("longitude"),
                "distance_meters": restaurant.get("distance_meters"),
                "doc_id": restaurant.get("doc_id"),
                "has_search_timestamp": restaurant.get("has_search_timestamp", False)
            })
        
        return results

    async def get_restaurants_details(self, place_ids: List[str], user_lat: float, user_lng: float,
                                    min_photo_height: int = 400, max_photos: int = 8) -> List[Dict[str, Any]]:
        """
        Get detailed restaurant data for multiple place_ids using Google Places API
        
        Args:
            place_ids: List of Google Place IDs (max 10)
            user_lat: User's latitude
            user_lng: User's longitude
            min_photo_height: Minimum photo height in pixels
            max_photos: Maximum number of photos to return
        
        Returns:
            List of detailed restaurant data
        """
        if not self.api_key:
            raise ValueError("GOOGLE_MAPS_API_KEY environment variable is required")
        
        if len(place_ids) > 10:
            raise ValueError("Maximum 10 place_ids allowed per request")
        
        results = []
        
        # Process each place_id
        for place_id in place_ids:
            print(f"DEBUG: Processing place_id: {place_id}")
            try:
                # Get place details from Google Places API
                print(f"DEBUG: Calling _get_place_details for {place_id}")
                place = await self._get_place_details(place_id)
                print(f"DEBUG: _get_place_details returned: {type(place)} - {place is not None}")
                
                if place is None:
                    print(f"DEBUG: place is None for {place_id}, creating error result")
                    results.append({
                        "place_id": place_id,
                        "error": "Google Places API returned None",
                        "name": None,
                        "distance_meters": None
                    })
                    continue
                
                # Get photo URLs
                print(f"DEBUG: Getting photo URLs for {place_id}")
                photo_urls = await self._get_photo_urls(place, min_photo_height, max_photos)
                print(f"DEBUG: photo_urls: {len(photo_urls) if photo_urls else 'None'}")
                
                # Calculate distance
                print(f"DEBUG: Calculating distance for {place_id}")
                distance_m = self._calculate_distance(place, user_lat, user_lng)
                print(f"DEBUG: distance_m: {distance_m}")
                
                # Build search result
                print(f"DEBUG: Building search result for {place_id}")
                search_result = self._build_search_result(place, photo_urls, distance_m)
                print(f"DEBUG: search_result type: {type(search_result)}, is None: {search_result is None}")
                print(f"DEBUG: search_result keys: {list(search_result.keys()) if search_result else 'None'}")
                
                results.append(search_result)
                print(f"DEBUG: Successfully processed {place_id}")
                
            except Exception as e:
                print(f"DEBUG: Exception processing place {place_id}: {str(e)}")
                print(f"DEBUG: Exception type: {type(e)}")
                import traceback
                traceback.print_exc()
                # Add error result
                results.append({
                    "place_id": place_id,
                    "error": str(e),
                    "name": None,
                    "distance_meters": None
                })
                continue
        
        return results

    async def get_place_details(self, place_id: str, user_lat: float, user_lng: float, 
                              min_photo_height: int = 400, max_photos: int = 8) -> Dict[str, Any]:
        """
        Get comprehensive place details from Google Places API
        
        Args:
            place_id: Google Place ID
            user_lat: User's latitude
            user_lng: User's longitude
            min_photo_height: Minimum photo height in pixels
            max_photos: Maximum number of photos to return
        
        Returns:
            Dictionary containing place details
        """
        if not self.api_key:
            raise ValueError("GOOGLE_MAPS_API_KEY environment variable is required")
        # Get place details from Google Places API
        place = await self._get_place_details(place_id)
        
        # Get photo URLs
        photo_urls = await self._get_photo_urls(place, min_photo_height, max_photos)
        
        # Calculate distance
        distance_m = self._calculate_distance(place, user_lat, user_lng)
        
        # Build final result
        return self._build_search_result(place, photo_urls, distance_m)


# Global instance
places_service = PlacesService()
