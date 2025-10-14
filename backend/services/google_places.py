import os, asyncio
from dotenv import load_dotenv
import httpx

load_dotenv()  # take environment variables from .env.
GOOGLE_PLACES_API_KEY = os.environ.get("GOOGLE_PLACES_API_KEY")

PLACES_SEARCH_URL = "https://maps.googleapis.com/maps/api/place/textsearch/json"
PLACES_DETAILS_URL = "https://maps.googleapis.com/maps/api/place/details/json"

async def text_search(query: str, lat=None, lng=None, radius_m=1500):
    params = {"query": query, "key": GOOGLE_PLACES_API_KEY}
    if lat and lng: params.update({"location": f"{lat},{lng}", "radius": radius_m})
    async with httpx.AsyncClient(timeout=10) as client:
        r = await client.get(PLACES_SEARCH_URL, params=params)
        r.raise_for_status()
        return r.json().get("results", [])
