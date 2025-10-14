from pydantic import BaseModel
from typing import List, Optional

class PlaceItem(BaseModel):
    name: str
    address: str
    google_place_id: Optional[str]
    in_database: bool

class PrunedPlacesResponse(BaseModel):
    kept: List[PlaceItem]
    dropped: List[PlaceItem]
    total_candidates: int
