import sys
import os
import asyncio

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import pytest

from places_service import PlacesService


@pytest.mark.asyncio
async def test_get_restaurants_details_with_mocked_helpers(monkeypatch):
    s = PlacesService()
    s.api_key = "fake_key"

    async def fake_get_place_details(self, place_id):
        return {
            "id": place_id,
            "displayName": {"text": "Mock Place"},
            "location": {"latitude": 1.0, "longitude": 2.0},
            "photos": [{"name": "photo1", "heightPx": 500}],
        }

    async def fake_get_photo_urls(self, place, min_photo_height, max_photos):
        return ["http://photo1"]

    # Patch the instance methods directly
    monkeypatch.setattr(PlacesService, "_get_place_details", fake_get_place_details)
    monkeypatch.setattr(PlacesService, "_get_photo_urls", fake_get_photo_urls)

    res = await s.get_restaurants_details(["p-1"], 1.0, 2.0)
    assert isinstance(res, list)
    assert len(res) == 1
    r = res[0]
    assert r["place_id"] == "p-1"
    assert r["photos"] == ["http://photo1"]


@pytest.mark.asyncio
async def test_search_nearby_restaurants_uses_firebase(monkeypatch):
    s = PlacesService()

    class FakeFirebase:
        async def get_nearby_restaurants(self, user_lat, user_lng, limit=10000):
            # return unsorted list with one inside radius and one outside
            return [
                {"place_id": "p_close", "name": "Close", "latitude": 0.0, "longitude": 0.0, "distance_meters": 100, "doc_id": "d1"},
                {"place_id": "p_far", "name": "Far", "latitude": 0.0, "longitude": 0.0, "distance_meters": 6000, "doc_id": "d2"},
            ]

    # Monkeypatch the firebase_service.get_firebase_service used by the function.
    import sys, types
    fake_mod = types.SimpleNamespace(get_firebase_service=lambda: FakeFirebase())
    sys.modules["firebase_service"] = fake_mod

    res = await s.search_nearby_restaurants(0.0, 0.0, radius_meters=5000)
    assert isinstance(res, list)
    # Only the close restaurant should be returned (within 5000m)
    assert any(r["place_id"] == "p_close" for r in res)
    assert not any(r["place_id"] == "p_far" for r in res)
