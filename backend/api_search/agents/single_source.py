# agents/single_source.py
import os
import asyncio
from typing import Dict, Any, List
from rapidfuzz import fuzz, process  # pip install rapidfuzz

from backend.api_search.services.google_places import text_search
from backend.api_search.services.firestore import db

DEMO = os.getenv("DEMO_MODE", "false").lower() == "true"

class SingleSourceSearch:
    async def search(self, payload) -> Dict[str, Any]:
        source = payload.source

        if source == "places":
            items = await self._search_places(payload)
            return {"source": "places", "total": len(items), "items": items}

        # default to db
        items = await self._search_db(payload)
        return {"source": "db", "total": len(items), "items": items}

    async def _search_places(self, payload) -> List[Dict[str, Any]]:
        # Demo stub (deterministic & instant)
        if DEMO:
            results = [
                {"name":"Sushi Kaji","address":"860 The Queensway, Etobicoke, ON","place_id":"DEMO_PID_1"},
                {"name":"Pai Downtown","address":"18 Duncan St, Toronto, ON","place_id":"DEMO_PID_2"},
                {"name":"Banh Mi Boys","address":"392 Queen St W, Toronto, ON","place_id":"DEMO_PID_3"},
            ]
        else:
            q = payload.google_place_id or payload.query or (payload.address or "")
            results = await text_search(q, lat=payload.lat, lng=payload.lng, radius_m=payload.radius_m)

        # normalize
        items = []
        for r in results:
            items.append({
                "name": r.get("name") or "Unknown",
                "address": r.get("formatted_address") or r.get("address") or "Address not available",
                "google_place_id": r.get("place_id")
            })
        return items

    async def _search_db(self, payload) -> List[Dict[str, Any]]:
        """Return top 10 restaurants closest to the specified lat/lng within radius_m.
           Strategy: pull all docs within a reasonable radius, calculate distance, sort by distance."""
        import math
        
        # Extract location from payload
        lat = payload.lat
        lng = payload.lng
        radius_m = payload.radius_m or 1000
        
        if lat is None or lng is None:
            return []
        
        # Pull all restaurants (we'll fetch in a thread to avoid blocking the event loop)
        def _fetch_docs():
            coll = db().collection("restaurants").limit(1000)  # manageable slice
            return [d.to_dict() | {"_id": d.id} for d in coll.stream()]

        docs = await asyncio.to_thread(_fetch_docs)
        
        # Calculate distance and filter by radius
        def haversine_distance(lat1, lon1, lat2, lon2):
            """Calculate distance in meters between two points."""
            R = 6371000  # Earth radius in meters
            phi1 = math.radians(lat1)
            phi2 = math.radians(lat2)
            delta_phi = math.radians(lat2 - lat1)
            delta_lambda = math.radians(lon2 - lon1)
            a = math.sin(delta_phi / 2) ** 2 + math.cos(phi1) * math.cos(phi2) * math.sin(delta_lambda / 2) ** 2
            c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
            return R * c
        
        def parse_number(v):
            try:
                if v is None:
                    return None
                # GeoPoint-like
                if hasattr(v, "latitude") and hasattr(v, "longitude"):
                    return float(v.latitude), float(v.longitude)
                if isinstance(v, (int, float)):
                    return float(v)
                if isinstance(v, str):
                    s = v.strip().replace('\u00B0', '').replace('°', '').replace('º', '')
                    parts = s.split()
                    num = float(parts[0].replace(',', ''))
                    if len(parts) > 1:
                        hemi = parts[1].upper()
                        if hemi in ("S", "W"):
                            num = -abs(num)
                    return num
            except Exception:
                return None

        candidates = []
        for d in docs:
            # Prefer explicit lat/lng fields if present
            rest_lat = d.get("lat")
            rest_lng = d.get("lng")

            if rest_lat is None or rest_lng is None:
                # Try location field
                location = d.get("location")
                if location is None:
                    # no usable location
                    continue

                # If location is a GeoPoint-like object
                if hasattr(location, "latitude") and hasattr(location, "longitude"):
                    rest_lat = float(location.latitude)
                    rest_lng = float(location.longitude)
                elif isinstance(location, (list, tuple)) and len(location) >= 2:
                    a = location[0]
                    b = location[1]
                    # Parse elements (they may be numbers or strings)
                    pv0 = parse_number(a)
                    pv1 = parse_number(b)
                    # If parse_number returned a tuple (GeoPoint), handle it
                    if isinstance(pv0, tuple) and len(pv0) == 2:
                        rest_lat, rest_lng = pv0[0], pv0[1]
                    elif isinstance(pv1, tuple) and len(pv1) == 2:
                        rest_lat, rest_lng = pv1[0], pv1[1]
                    else:
                        # Decide order heuristically: if first value magnitude > 90 it's longitude
                        if pv0 is None or pv1 is None:
                            continue
                        if abs(pv0) > 90 and abs(pv1) <= 90:
                            # [lng, lat]
                            rest_lng = float(pv0)
                            rest_lat = float(pv1)
                        elif abs(pv1) > 90 and abs(pv0) <= 90:
                            # [lat, lng] but second looks like longitude
                            rest_lng = float(pv1)
                            rest_lat = float(pv0)
                        else:
                            # both within [-90,90], assume [lat, lng]
                            rest_lat = float(pv0)
                            rest_lng = float(pv1)
                else:
                    continue

            # Ensure numeric
            try:
                rest_lat = float(rest_lat)
                rest_lng = float(rest_lng)
            except Exception:
                continue

            distance = haversine_distance(lat, lng, rest_lat, rest_lng)

            if distance <= radius_m:
                # Return all document fields plus computed distance metrics
                item = dict(d)  # Copy all fields from the document
                
                # Recursively convert non-serializable types to JSON-safe formats
                def serialize_value(value):
                    """Recursively convert Firestore types to JSON-safe equivalents."""
                    if value is None:
                        return None
                    
                    # GeoPoint -> [lat, lng]
                    if hasattr(value, "latitude") and hasattr(value, "longitude"):
                        return [value.latitude, value.longitude]
                    
                    # Timestamp/datetime -> ISO string
                    if hasattr(value, "isoformat"):
                        return value.isoformat()
                    
                    # Recursively handle dicts
                    if isinstance(value, dict):
                        return {k: serialize_value(v) for k, v in value.items()}
                    
                    # Recursively handle lists and tuples
                    if isinstance(value, (list, tuple)):
                        return [serialize_value(v) for v in value]
                    
                    # Return as-is for primitives (str, int, float, bool)
                    return value
                
                # Serialize all fields
                item = serialize_value(item)
                item["distance_m"] = round(distance, 1)
                item["distance_km"] = round(distance / 1000, 2)
                candidates.append(item)

        # Sort and return top 10
        candidates.sort(key=lambda x: x["distance_m"])
        return candidates[:10]
