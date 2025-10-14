from pydantic import BaseModel
from typing import List, Optional

class PlaceItem(BaseModel):
    name: str
    address: str
    google_place_id: Optional[str]
    score: Optional[float] = None 

class SearchResponse(BaseModel):
    source: str
    total: int
    items: List[PlaceItem]
