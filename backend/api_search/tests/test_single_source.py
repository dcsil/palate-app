import sys
import os
import asyncio
from unittest.mock import AsyncMock, MagicMock, patch

# Add project root to path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..')))
# Also add the package dir so absolute imports like `services.*` resolve to `backend/api_search/services`
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import pytest

from backend.api_search.agents.single_source import SingleSourceSearch


class Payload:
    def __init__(self, **kwargs):
        for k, v in kwargs.items():
            setattr(self, k, v)


@pytest.mark.asyncio
async def test_search_places_demo_mode(monkeypatch):
    monkeypatch.setattr('backend.api_search.agents.single_source.DEMO', True)
    s = SingleSourceSearch()
    p = Payload(source='places', google_place_id=None, query=None, address=None, lat=None, lng=None, radius_m=None)
    res = await s.search(p)
    assert res['source'] == 'places'
    assert res['total'] > 0


@pytest.mark.asyncio
async def test_search_places_live_mode(monkeypatch):
    monkeypatch.setattr('backend.api_search.agents.single_source.DEMO', False)
    fake_results = [
        {"name": "Live A", "formatted_address": "Addr A", "place_id": "pidA"}
    ]
    monkeypatch.setattr('backend.api_search.agents.single_source.text_search', AsyncMock(return_value=fake_results))

    s = SingleSourceSearch()
    p = Payload(source='places', google_place_id=None, query='q', address=None, lat=None, lng=None, radius_m=None)
    res = await s.search(p)
    assert res['source'] == 'places'
    assert res['total'] == 1
    assert res['items'][0]['google_place_id'] == 'pidA'


@pytest.mark.asyncio
async def test_search_db_parsing_and_distance(monkeypatch):
    # Build fake doc object with location as [lat, lng]
    class FakeDoc:
        def __init__(self, d, id_='d1'):
            self._d = d
            self.id = id_

        def to_dict(self):
            return dict(self._d)

    docs = [FakeDoc({'location': [43.7, -79.4], 'name': 'Near'})]

    class FakeColl:
        def limit(self, n):
            return self

        def stream(self):
            return iter(docs)

    class FakeDB:
        def collection(self, name):
            return FakeColl()

    monkeypatch.setattr('backend.api_search.agents.single_source.db', lambda: FakeDB())

    s = SingleSourceSearch()
    p = Payload(source='db', lat=43.7, lng=-79.4, radius_m=1000)
    res = await s.search(p)
    assert res['source'] == 'db'
    assert res['total'] == 1
    assert 'distance_m' in res['items'][0]
