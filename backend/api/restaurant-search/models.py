"""
Data models for the restaurant search API
"""
from typing import Optional, List, Dict, Any
from pydantic import BaseModel, Field


class GeoPoint(BaseModel):
    """GeoPoint model for coordinates"""
    latitude: float = Field(..., description="Latitude coordinate", ge=-90, le=90)
    longitude: float = Field(..., description="Longitude coordinate", ge=-180, le=180)


class LocationInfo(BaseModel):
    """Model for location information from Google Places API"""
    neighborhood: Optional[str] = Field(None, description="Neighborhood name")
    city: Optional[str] = Field(None, description="City name")


class LocationResponse(BaseModel):
    """Response model for location endpoint"""
    success: bool = Field(..., description="Whether the request was successful")
    neighborhood: Optional[str] = Field(None, description="Neighborhood name")
    city: Optional[str] = Field(None, description="City name")
    error: Optional[str] = Field(None, description="Error message if unsuccessful")


class RestaurantSearchRequest(BaseModel):
    """Request model for restaurant search by radius"""
    center: GeoPoint = Field(..., description="Center point for search")
    radius_km: float = Field(..., description="Search radius in kilometers", gt=0, le=50)


class Restaurant(BaseModel):
    """Model for restaurant data"""
    doc_id: str = Field(..., description="Firebase document ID")
    place_id: Optional[str] = Field(None, description="Google Place ID")
    name: str = Field(..., description="Restaurant name")
    location: GeoPoint = Field(..., description="Restaurant location as GeoPoint")
    distance_km: float = Field(..., description="Distance from center in kilometers")


class RestaurantSearchResponse(BaseModel):
    """Response model for restaurant search endpoint"""
    restaurants: List[Restaurant] = Field(..., description="List of restaurants found")
    total_found: int = Field(..., description="Total number of restaurants found")


class RestaurantDetailsRequest(BaseModel):
    """Request model for restaurant details endpoint"""
    place_id: str = Field(..., description="Google Place ID")
    location: GeoPoint = Field(..., description="Location coordinates (required)")


class DeleteRestaurantRequest(BaseModel):
    """Request model for delete restaurant endpoint"""
    place_id: str = Field(..., description="Google Place ID of restaurant to delete")


class DeleteRestaurantResponse(BaseModel):
    """Response model for delete restaurant endpoint"""
    success: bool = Field(..., description="Whether the deletion was successful")
    message: str = Field(..., description="Success or error message")
    place_id: str = Field(..., description="Google Place ID that was processed")


class MultipleRestaurantDetailsRequest(BaseModel):
    """Request model for multiple restaurant details endpoint"""
    place_ids: List[str] = Field(..., description="List of Google Place IDs", min_items=1, max_items=20)
    location: GeoPoint = Field(..., description="Location coordinates (required)")


class RestaurantDetailsItem(BaseModel):
    """Individual restaurant details item with place_id for identification"""
    place_id: str = Field(..., description="Google Place ID")
    # Basic Info (Place Details Essentials)
    name: Optional[str] = Field(None, description="Restaurant name")
    business_status: Optional[str] = Field(None, description="Business status")
    rating: Optional[float] = Field(None, description="Restaurant rating")
    price_level: Optional[int] = Field(None, description="Price level (0-4)")
    
    # Location & Contact (Place Details Essentials)
    formatted_address: Optional[str] = Field(None, description="Full formatted address")
    phone_number: Optional[str] = Field(None, description="Phone number")
    international_phone_number: Optional[str] = Field(None, description="International phone number")
    
    # Categories & Types (Place Details Essentials)
    primary_type: Optional[str] = Field(None, description="Primary business type")
    types: Optional[List[str]] = Field(None, description="All business types")
    
    # Hours (Place Details Pro)
    regular_opening_hours: Optional[Dict[str, Any]] = Field(None, description="Regular opening hours")
    
    # Reviews & Content (Place Details Pro)
    editorial_summary: Optional[Dict[str, Any]] = Field(None, description="Editorial summary")
    generative_summary: Optional[Dict[str, Any]] = Field(None, description="AI-generated summary")
    review_summary: Optional[Dict[str, Any]] = Field(None, description="Review summary")
    
    # Media (Place Details Pro)
    photos: Optional[List[str]] = Field(None, description="Photo URLs")
    
    # Maps Integration (Place Details Essentials)
    google_maps_uri: Optional[str] = Field(None, description="Google Maps URI")
    website_uri: Optional[str] = Field(None, description="Website URI")
    
    # Enterprise Level Fields
    user_rating_count: Optional[int] = Field(None, description="Number of user ratings")
    
    # Enterprise + Atmosphere Fields
    # Service Options
    takeout: Optional[bool] = Field(None, description="Takeout available")
    delivery: Optional[bool] = Field(None, description="Delivery available")
    dine_in: Optional[bool] = Field(None, description="Dine-in available")
    curbside_pickup: Optional[bool] = Field(None, description="Curbside pickup available")
    reservable: Optional[bool] = Field(None, description="Reservations available")
    
    # Food & Beverage
    serves_breakfast: Optional[bool] = Field(None, description="Serves breakfast")
    serves_lunch: Optional[bool] = Field(None, description="Serves lunch")
    serves_dinner: Optional[bool] = Field(None, description="Serves dinner")
    serves_beer: Optional[bool] = Field(None, description="Serves beer")
    serves_wine: Optional[bool] = Field(None, description="Serves wine")
    serves_cocktails: Optional[bool] = Field(None, description="Serves cocktails")
    serves_vegetarian_food: Optional[bool] = Field(None, description="Serves vegetarian food")
    
    # Ambience & Amenities
    outdoor_seating: Optional[bool] = Field(None, description="Has outdoor seating")
    live_music: Optional[bool] = Field(None, description="Has live music")
    good_for_groups: Optional[bool] = Field(None, description="Good for groups")
    good_for_children: Optional[bool] = Field(None, description="Good for children")
    good_for_watching_sports: Optional[bool] = Field(None, description="Good for watching sports")
    allows_dogs: Optional[bool] = Field(None, description="Allows dogs")
    restroom: Optional[bool] = Field(None, description="Has restroom")
    
    # Accessibility & Payment
    accessibility_options: Optional[Dict[str, Any]] = Field(None, description="Accessibility options")
    payment_options: Optional[Dict[str, Any]] = Field(None, description="Payment options")
    parking_options: Optional[Dict[str, Any]] = Field(None, description="Parking options")


class MultipleRestaurantDetailsResponse(BaseModel):
    """Response model for multiple restaurant details endpoint"""
    restaurants: List[RestaurantDetailsItem] = Field(..., description="List of restaurant details")
    total_found: int = Field(..., description="Total number of restaurants found")
    errors: Optional[List[Dict[str, str]]] = Field(None, description="List of errors for failed place_ids")


class RestaurantDetailsResponse(BaseModel):
    """Response model for comprehensive restaurant details including Enterprise and Enterprise + Atmosphere"""
    # Basic Info (Place Details Essentials)
    name: Optional[str] = Field(None, description="Restaurant name")
    business_status: Optional[str] = Field(None, description="Business status")
    rating: Optional[float] = Field(None, description="Restaurant rating")
    price_level: Optional[int] = Field(None, description="Price level (0-4)")
    
    # Location & Contact (Place Details Essentials)
    formatted_address: Optional[str] = Field(None, description="Full formatted address")
    phone_number: Optional[str] = Field(None, description="Phone number")
    international_phone_number: Optional[str] = Field(None, description="International phone number")
    
    # Categories & Types (Place Details Essentials)
    primary_type: Optional[str] = Field(None, description="Primary business type")
    types: Optional[List[str]] = Field(None, description="All business types")
    
    # Hours (Place Details Pro)
    regular_opening_hours: Optional[Dict[str, Any]] = Field(None, description="Regular opening hours")
    
    # Reviews & Content (Place Details Pro)
    editorial_summary: Optional[Dict[str, Any]] = Field(None, description="Editorial summary")
    generative_summary: Optional[Dict[str, Any]] = Field(None, description="AI-generated summary")
    review_summary: Optional[Dict[str, Any]] = Field(None, description="Review summary")
    
    # Media (Place Details Pro)
    photos: Optional[List[str]] = Field(None, description="Photo URLs")
    
    # Maps Integration (Place Details Essentials)
    google_maps_uri: Optional[str] = Field(None, description="Google Maps URI")
    website_uri: Optional[str] = Field(None, description="Website URI")
    
    # Enterprise Level Fields
    user_rating_count: Optional[int] = Field(None, description="Number of user ratings")
    
    # Enterprise + Atmosphere Fields
    # Service Options
    takeout: Optional[bool] = Field(None, description="Takeout available")
    delivery: Optional[bool] = Field(None, description="Delivery available")
    dine_in: Optional[bool] = Field(None, description="Dine-in available")
    curbside_pickup: Optional[bool] = Field(None, description="Curbside pickup available")
    reservable: Optional[bool] = Field(None, description="Reservations available")
    
    # Food & Beverage
    serves_breakfast: Optional[bool] = Field(None, description="Serves breakfast")
    serves_lunch: Optional[bool] = Field(None, description="Serves lunch")
    serves_dinner: Optional[bool] = Field(None, description="Serves dinner")
    serves_beer: Optional[bool] = Field(None, description="Serves beer")
    serves_wine: Optional[bool] = Field(None, description="Serves wine")
    serves_cocktails: Optional[bool] = Field(None, description="Serves cocktails")
    serves_vegetarian_food: Optional[bool] = Field(None, description="Serves vegetarian food")
    
    # Ambience & Amenities
    outdoor_seating: Optional[bool] = Field(None, description="Has outdoor seating")
    live_music: Optional[bool] = Field(None, description="Has live music")
    good_for_groups: Optional[bool] = Field(None, description="Good for groups")
    good_for_children: Optional[bool] = Field(None, description="Good for children")
    good_for_watching_sports: Optional[bool] = Field(None, description="Good for watching sports")
    allows_dogs: Optional[bool] = Field(None, description="Allows dogs")
    restroom: Optional[bool] = Field(None, description="Has restroom")
    
    # Accessibility & Payment
    accessibility_options: Optional[Dict[str, Any]] = Field(None, description="Accessibility options")
    payment_options: Optional[Dict[str, Any]] = Field(None, description="Payment options")
    parking_options: Optional[Dict[str, Any]] = Field(None, description="Parking options")
