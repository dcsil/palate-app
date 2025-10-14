from fastapi import APIRouter, Depends
from app.models.requests import PlaceQuery
from app.models.responses import SearchResponse
from app.deps import get_single_source_search

router = APIRouter(tags=["search"])

@router.post("/agent/search", response_model=SearchResponse)

async def search(payload: PlaceQuery, svc=Depends(get_single_source_search)):
    return await svc.search(payload)
