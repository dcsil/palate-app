from pydantic import BaseModel, ConfigDict
from typing import List, Optional, Any, Dict

class PlaceItem(BaseModel):
    model_config = ConfigDict(extra="allow")  # Allow arbitrary additional fields
    
    name: Optional[str] = None
    address: Optional[str] = None
    google_place_id: Optional[str] = None
    score: Optional[float] = None 
    distance_m: Optional[float] = None  # distance in meters
    distance_km: Optional[float] = None  # distance in kilometers

class SearchResponse(BaseModel):
    source: str
    total: int
    items: List[Dict[str, Any]]  # Use plain dicts instead of PlaceItem model


class RankedRestaurantItem(BaseModel):
    restaurant: Dict[str, Any] = {}
    justification: str


class RankResponse(BaseModel):
    ranked_restaurants: List[RankedRestaurantItem]
    total_restaurants: int
