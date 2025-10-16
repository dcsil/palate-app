"""
Data models and type definitions for the restaurant search API
"""
from typing import List, Optional, Dict, Any
from pydantic import BaseModel, Field


class LatLng(BaseModel):
    """Model for latitude and longitude coordinates"""
    lat: float
    lng: float


class NearbyRestaurant(BaseModel):
    """Model for nearby restaurant search results"""
    doc_id: str
    place_id: str
    name: str
    location: LatLng 
    distance_meters: Optional[float]
    has_search_timestamp: bool
    search_result: Optional['PlaceSearchResult'] = None
    error: Optional[str] = None


class NearbyRestaurantsResponse(BaseModel):
    """Model for nearby restaurants endpoint response"""
    restaurants: List[NearbyRestaurant]
    total_found: int
    updated_count: int


class PlaceSearchResult(BaseModel):
    """Model for place search results"""
    place_id: str
    name: str
    photos: List[str]
    distance_meters: Optional[float]
    
    # Hours
    hours: Dict[str, Any]
    
    # Service options
    service_options: Dict[str, Any]
    
    # Ambience & amenities
    ambience: Dict[str, Any]
    accessibility_options: Optional[Dict[str, Any]]
    payment_options: Optional[Dict[str, Any]]
    parking_options: Optional[Dict[str, Any]]
    
    # Summaries
    editorial_summary: Optional[str]
    generative_summary: Dict[str, Any]
    review_summary: Optional[Dict[str, Any]]
    
    # Basic info
    rating: Optional[float]
    user_rating_count: Optional[int]
    price_level: Optional[int]
    primary_type: Optional[str]
    types: Optional[List[str]]
    maps_links: Optional[Dict[str, Any]]
    
    # Firebase status
    firebase_updated: Optional[bool] = None
    firebase_message: Optional[str] = None
    firebase_error: Optional[str] = None


class HealthResponse(BaseModel):
    """Model for health check response"""
    status: str


class RootResponse(BaseModel):
    """Model for root endpoint response"""
    message: str


class RestaurantSearchResult(BaseModel):
    """Model for restaurant search result (basic info)"""
    place_id: str
    name: str
    latitude: float
    longitude: float
    distance_meters: float
    doc_id: str
    has_search_timestamp: bool


class RestaurantSearchResponse(BaseModel):
    """Model for restaurant search response"""
    restaurants: List[RestaurantSearchResult]
    total_found: int


class RestaurantDetailsRequest(BaseModel):
    """Model for restaurant details request"""
    place_ids: List[str] = Field(..., min_items=1, max_items=10, description="List of place IDs (max 10)")
    user_lat: float = Field(..., description="User latitude")
    user_lng: float = Field(..., description="User longitude")