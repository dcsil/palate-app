from langchain.tools import tool
from services.google_places import text_search

@tool("places_text_search", return_direct=False)
async def places_text_search_tool(query: str, lat: float|None=None, lng: float|None=None, radius_m: int=1500):
    """Search Google Places for restaurants given a query and optional location."""
    results = await text_search(query, lat, lng, radius_m)
    # normalize minimal fields
    norm = []
    for r in results:
        norm.append({
            "name": r.get("name"),
            "address": r.get("formatted_address"),
            "place_id": r.get("place_id"),
        })
    return norm
