from fastapi import APIRouter, Depends
from ..models.requests import PlaceQuery, RankRequest
from ..models.responses import SearchResponse, RankResponse
from ..deps import get_single_source_search, get_rank_agent

router = APIRouter(tags=["search"])

@router.post("/agent/search", response_model=SearchResponse)
async def search(payload: PlaceQuery, svc=Depends(get_single_source_search)):
    return await svc.search(payload)


@router.post("/agent/rank", response_model=RankResponse)
async def rank(payload: RankRequest, rank_agent=Depends(get_rank_agent)):
    return await rank_agent.run(payload.restaurants, payload.taste_vector)
