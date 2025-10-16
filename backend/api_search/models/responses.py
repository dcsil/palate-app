from pydantic import BaseModel
from typing import List, Optional

class PlaceItem(BaseModel):
    name: str
    address: Optional[str] = None
    google_place_id: Optional[str] = None
    score: Optional[float] = None 

class SearchResponse(BaseModel):
    source: str
    total: int
    items: List[PlaceItem]
