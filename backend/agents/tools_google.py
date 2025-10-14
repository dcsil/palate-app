from langchain.tools import tool
from services.google_places import text_search
import os
from dotenv import load_dotenv
load_dotenv()  # take environment variables from .env.

DEMO_MODE = os.getenv("DEMO_MODE", "false").lower() == "true"

@tool("places_text_search", return_direct=False)
async def places_text_search_tool(query: str, lat: float|None=None, lng: float|None=None, radius_m: int=1500):
    """Search Google Places for restaurants given a query and optional location."""
    if DEMO_MODE:
        # Hardcoded, deterministic set for class demo
        return [
            {"name": "Sushi Kaji", "address": "860 The Queensway, Etobicoke, ON",
                "place_id": "DEMO_PID_1"},
            {"name": "Pai Downtown", "address": "18 Duncan St, Toronto, ON",
                "place_id": "DEMO_PID_2"},
            {"name": "Banh Mi Boys", "address": "392 Queen St W, Toronto, ON",
                "place_id": "DEMO_PID_3"},
        ]
    
    # Normal path
    
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
