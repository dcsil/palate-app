import asyncio
import types
import sys
import os
import pytest

import importlib.util

# Load firebase_service module directly from file to avoid package-name issues
mod_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'firebase_service.py'))
spec = importlib.util.spec_from_file_location("firebase_service", mod_path)
fs_mod = importlib.util.module_from_spec(spec)
spec.loader.exec_module(fs_mod)


def test_calculate_bounding_box_and_haversine():
    # Create instance without running __init__
    inst = object.__new__(fs_mod.FirebaseService)

    bbox = fs_mod.FirebaseService._calculate_bounding_box(inst, 37.0, -122.0, 5.0)
    assert 'min_lat' in bbox and 'max_lat' in bbox

    # Haversine between same points is ~0
    dist = fs_mod.FirebaseService._haversine_distance(inst, 37.0, -122.0, 37.0, -122.0)
    assert pytest.approx(dist, rel=1e-6) == 0


@pytest.mark.asyncio
async def test_is_restaurant_details_stale_various_timestamp_types():
    inst = object.__new__(fs_mod.FirebaseService)

    # Monkeypatch get_restaurant_by_place_id to return dicts with search_timestamp
    async def fake_get_restaurant_by_place_id_str(place_id):
        return {"search_timestamp": "2000-01-01T00:00:00Z"}

    async def fake_get_restaurant_by_place_id_dt(place_id):
        from datetime import datetime, timedelta
        return {"search_timestamp": datetime.now()}

    inst.get_restaurant_by_place_id = fake_get_restaurant_by_place_id_str
    stale = await fs_mod.FirebaseService.is_restaurant_details_stale(inst, "p1", days_threshold=1)
    assert stale is True

    inst.get_restaurant_by_place_id = fake_get_restaurant_by_place_id_dt
    stale = await fs_mod.FirebaseService.is_restaurant_details_stale(inst, "p1", days_threshold=1)
    assert stale is False
