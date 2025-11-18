from pydantic import BaseModel, Field
from typing import Optional, Literal, List, Any, Dict

class PlaceQuery(BaseModel):
    query: Optional[str] = Field(None, description="Free-text name or query for places")
    address: Optional[str] = None
    google_place_id: Optional[str] = None
    lat: Optional[float] = None
    lng: Optional[float] = None
    radius_m: Optional[int] = Field(1000, description="Search radius in meters")
    source: Literal["places", "db"] = "places"
    debug: Optional[bool] = Field(False, description="Return full raw data structure")


class UserImplicitData(BaseModel):
    likes: List[Dict[str, Any]] = Field(default_factory=list, description="List of restaurant data for restaurants user liked")
    saved: List[Dict[str, Any]] = Field(default_factory=list, description="List of saved restaurant data")
    visited: List[Dict[str, Any]] = Field(default_factory=list, description="List of visited restaurant data")
    disliked: List[Dict[str, Any]] = Field(default_factory=list, description="List of disliked restaurant data")


class RankRequest(BaseModel):
    restaurants: List[Dict[str, Any]] = Field(..., description="List of restaurant dictionaries from single_source search")
    taste_vector: List[str] = Field(..., description="List of keywords/attributes user cares about (e.g., ['cozy', 'aesthetic', 'student-friendly'])")
    user_data: Optional[UserImplicitData] = Field(None, description="User's implicit restaurant data (likes, saved, visited, disliked)")
