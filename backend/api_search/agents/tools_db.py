from langchain.tools import tool

from ..services.firestore import restaurant_by_place_ids

@tool("db_filter_known_place_ids", return_direct=False)
def db_filter_known_place_ids(place_ids: list[str]):
    """Return the subset of place_ids that exist in our database."""
    return list(restaurant_by_place_ids(place_ids))
