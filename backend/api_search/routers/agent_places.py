from fastapi import APIRouter, Depends, Body
from typing import List, Dict, Any, Optional
from backend.api_search.models.requests import PlaceQuery, UserImplicitData
from backend.api_search.models.responses import SearchResponse, RankResponse
from backend.api_search.deps import get_single_source_search, get_rank_agent

router = APIRouter(tags=["search"])

@router.post("/agent/search", response_model=SearchResponse)
async def search(payload: PlaceQuery, svc=Depends(get_single_source_search)):
    return await svc.search(payload)


@router.post("/agent/rank", response_model=RankResponse)
async def rank(
    place_ids: List[str] = Body(..., description="List of place IDs (Google Place IDs) to rank"),
    palate_archetype: str = Body(..., description="User's palate archetype (must match one of: Explorer, Purist, Social Curator, Trend Seeker, Conformist, Aestheticist)"),
    user_data: Optional[UserImplicitData] = Body(None, description="User's implicit restaurant data (likes, saved, visited, disliked)"),
    rank_agent=Depends(get_rank_agent)
):
    user_data_dict = user_data.model_dump() if user_data else None
    return await rank_agent.run(place_ids, palate_archetype, user_data_dict)
