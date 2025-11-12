
from dataclasses import dataclass
from typing import Any, Dict, Iterable, List, Tuple, Optional
import math
import re
import logging
from places_pruner import build_places_pruner_agent

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

@dataclass
class Place:
    id: str
    name: str
    lat: float
    lng: float
    address: Optional[str] = None
    rating: float | None = None
    price_level: int | None = None
    cuisines: List[str] | None = None
    tags: List[str] | None = None
    text_blob: str | None = None
    raw: Dict[str, Any] | None = None

@dataclass
class RankedPlace:
    place: Place
    score: float
    matched: List[str]
    reasons: Dict[str, float]


