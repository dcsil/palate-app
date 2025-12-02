import sys
import os
import types
import asyncio

import pytest

import importlib.util
import os

# Load main.py directly from file path to avoid package import issues
mod_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'main.py'))
spec = importlib.util.spec_from_file_location("main", mod_path)
main = importlib.util.module_from_spec(spec)
spec.loader.exec_module(main)


class DummyBackgroundTasks:
    def __init__(self):
        self.tasks = []

    def add_task(self, func, *args, **kwargs):
        self.tasks.append((func, args, kwargs))


@pytest.mark.asyncio
async def test_get_single_restaurant_details_uses_firebase():
    # Fake firebase service that returns fresh details
    class FakeFirebase:
        async def get_restaurant_details_from_firebase(self, place_id):
            return {"name": "FromFirebase"}

    place_id, details, source = await main.get_single_restaurant_details("p1", FakeFirebase())
    assert place_id == "p1"
    assert source == "firebase"
    assert details["name"] == "FromFirebase"


@pytest.mark.asyncio
async def test_get_single_restaurant_details_falls_back_to_google(monkeypatch):
    # Fake firebase service that returns None
    class FakeFirebase:
        async def get_restaurant_details_from_firebase(self, place_id):
            return None

    async def fake_places_detail(place_id):
        return {"name": "FromGoogle"}

    monkeypatch.setattr(main, "places_service", types.SimpleNamespace(get_restaurant_details=fake_places_detail))

    place_id, details, source = await main.get_single_restaurant_details("p2", FakeFirebase())
    assert source == "google_places"
    assert details["name"] == "FromGoogle"


@pytest.mark.asyncio
async def test_get_multiple_restaurant_details_concurrent(monkeypatch):
    # Fake firebase that always returns None to force google fetch
    class FakeFirebase:
        async def get_restaurant_details_from_firebase(self, place_id):
            return None

        async def update_restaurant_details(self, place_id, details):
            return True

    async def fake_places_detail(place_id):
        return {"name": f"G-{place_id}", "price_level": 2}

    monkeypatch.setattr(main, "places_service", types.SimpleNamespace(get_restaurant_details=fake_places_detail))
    monkeypatch.setattr(main, "get_firebase_service", lambda: FakeFirebase())

    # Build a lightweight request object
    class Req:
        def __init__(self):
            self.place_ids = ["a", "b"]
            self.location = types.SimpleNamespace(latitude=0.0, longitude=0.0)

    bg = DummyBackgroundTasks()
    res = await main.get_multiple_restaurant_details(Req(), bg)
    assert res.total_found == 2

    # background tasks should be added for both place_ids (google_places)
    assert len(bg.tasks) == 2


@pytest.mark.asyncio
async def test_update_restaurant_details_background_calls_update(monkeypatch):
    recorded = {}

    class FakeFirebase:
        async def update_restaurant_details(self, place_id, details):
            recorded['updated'] = place_id
            return True

    async def fake_places_detail(place_id):
        return {"name": "X"}

    monkeypatch.setattr(main, "places_service", types.SimpleNamespace(get_restaurant_details=fake_places_detail))
    monkeypatch.setattr(main, "get_firebase_service", lambda: FakeFirebase())

    await main.update_restaurant_details_background("p-upd")
    assert recorded.get('updated') == "p-upd"
