from pydantic import BaseModel, Field
from typing import Optional, Literal

class PlaceQuery(BaseModel):
    query: Optional[str] = Field(None, description="Free-text name or query for places")
    address: Optional[str] = None
    google_place_id: Optional[str] = None
    lat: Optional[float] = None
    lng: Optional[float] = None
    radius_m: Optional[int] = Field(1000, description="Search radius in meters")
    source: Literal["places", "db"] = "places"
    debug: Optional[bool] = Field(False, description="Return full raw data structure")
