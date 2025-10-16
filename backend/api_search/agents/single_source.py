# agents/single_source.py
import os
from typing import Dict, Any, List
from rapidfuzz import fuzz, process  # pip install rapidfuzz

from services.google_places import text_search
from services.firestore import db

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
        """Fast fuzzy search over Firestore 'restaurants' collection.
           Strategy: pull a small slice (e.g., by city or prefix), then fuzzy match client-side.
           For demo, we just pull first N docs; for production, add indexed filters (city, cuisine)."""
        q = (payload.query or payload.address or payload.google_place_id or "").strip()
        if not q:
            return []

        # Pull a manageable slice (adjust filters as your schema supports)
        # Example: filter by city if you pass it in payload later; else limit N.
        coll = db().collection("restaurants").limit(500)  # keep it small for speed
        docs = [d.to_dict() | {"_id": d.id} for d in coll.stream()]

        # Build corpus (name + address) for fuzzy match
        corpus = []
        for d in docs:
            corpus.append((d.get("name","") + " " + d.get("address","")).strip() or d.get("name",""))

        # Fuzzy match: top 25 with score >= 60 (tune as needed)
        matches = process.extract(q, corpus, scorer=fuzz.token_set_ratio, limit=25)
        # matches -> list of tuples: (text, score, index)

        out = []
        for text, score, idx in matches:
            if score < 60:  # threshold
                continue
            d = docs[idx]
            out.append({
                "name": d.get("name") or "Unknown",
                "address": d.get("address") or "Address not available",
                "google_place_id": d.get("google_place_id"),
                "score": float(score)
            })
        return out
