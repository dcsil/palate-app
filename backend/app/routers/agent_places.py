from fastapi import APIRouter, Depends
from app.deps import get_places_pruner_agent
from app.models.requests import PlaceQuery
from app.models.responses import PrunedPlacesResponse

router = APIRouter(tags=["Agent Places"])

@router.post("/agent/places-prune", response_model=PrunedPlacesResponse)

async def places_prune(query: PlaceQuery, agent=Depends(get_places_pruner_agent)):
    pruned_places = await agent.run(query)
    return pruned_places
