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
        fields = self._get_required_fields()
        headers = {
            "X-Goog-Api-Key": self.api_key,
            "X-Goog-FieldMask": fields,
        }
        
        details_url = f"{self.base_url}/places/{place_id}"
        async with httpx.AsyncClient(timeout=15) as client:
            response = await client.get(details_url, headers=headers)
            if response.status_code != 200:
                raise Exception(f"Places API error: {response.status_code} - {response.text}")
            return response.json()
    
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
        return {
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
