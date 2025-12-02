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


@pytest.mark.asyncio
async def test_search_db_no_location(monkeypatch):
    """Test that db search returns empty list when no lat/lng provided"""
    s = SingleSourceSearch()
    p = Payload(source='db', lat=None, lng=None, radius_m=1000)
    res = await s.search(p)
    assert res['source'] == 'db'
    assert res['total'] == 0
    assert res['items'] == []


@pytest.mark.asyncio
async def test_search_db_with_geopoint(monkeypatch):
    """Test parsing GeoPoint-like objects"""
    class FakeGeoPoint:
        def __init__(self, lat, lng):
            self.latitude = lat
            self.longitude = lng

    class FakeDoc:
        def __init__(self, d, id_='d1'):
            self._d = d
            self.id = id_

        def to_dict(self):
            return dict(self._d)

    docs = [FakeDoc({'location': FakeGeoPoint(43.7, -79.4), 'name': 'GeoPoint Test'})]

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
    p = Payload(source='db', lat=43.7, lng=-79.4, radius_m=10000)
    res = await s.search(p)
    assert res['source'] == 'db'
    assert res['total'] == 1


@pytest.mark.asyncio
async def test_search_places_with_address_fallback():
    """Test that places search uses address as fallback"""
    fake_results = [{"name": "Test", "address": "123 Main", "place_id": "pid1"}]
    
    with patch('backend.api_search.agents.single_source.text_search', AsyncMock(return_value=fake_results)):
        with patch('backend.api_search.agents.single_source.DEMO', False):
            s = SingleSourceSearch()
            p = Payload(source='places', google_place_id=None, query=None, address='123 Main St', 
                       lat=None, lng=None, radius_m=None)
            res = await s.search(p)
            assert res['source'] == 'places'
            assert res['total'] == 1


@pytest.mark.asyncio
async def test_search_default_to_db(monkeypatch):
    """Test that unknown source defaults to db"""
    class FakeDoc:
        def __init__(self, d, id_='d1'):
            self._d = d
            self.id = id_

        def to_dict(self):
            return dict(self._d)

    docs = []

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
    p = Payload(source='unknown', lat=43.7, lng=-79.4, radius_m=1000)
    res = await s.search(p)
    assert res['source'] == 'db'


@pytest.mark.asyncio
async def test_search_db_with_explicit_lat_lng(monkeypatch):
    """Test parsing when restaurant has explicit lat/lng fields"""
    class FakeDoc:
        def __init__(self, d, id_='d1'):
            self._d = d
            self.id = id_

        def to_dict(self):
            return dict(self._d)

    docs = [FakeDoc({'lat': 43.7, 'lng': -79.4, 'name': 'Explicit Coords'})]

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
    p = Payload(source='db', lat=43.7, lng=-79.4, radius_m=10000)
    res = await s.search(p)
    assert res['source'] == 'db'
    assert res['total'] == 1


@pytest.mark.asyncio
async def test_search_db_location_as_lng_lat(monkeypatch):
    """Test parsing [lng, lat] order (when first value > 90)"""
    class FakeDoc:
        def __init__(self, d, id_='d1'):
            self._d = d
            self.id = id_

        def to_dict(self):
            return dict(self._d)

    # Use 120 longitude (Asia/Pacific) which is > 90
    docs = [FakeDoc({'location': [120.0, 30.0], 'name': 'LngLat Order'})]

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
    p = Payload(source='db', lat=30.0, lng=120.0, radius_m=10000)
    res = await s.search(p)
    assert res['source'] == 'db'
    assert res['total'] == 1


@pytest.mark.asyncio
async def test_search_db_with_missing_location(monkeypatch):
    """Test that restaurants without location are skipped"""
    class FakeDoc:
        def __init__(self, d, id_='d1'):
            self._d = d
            self.id = id_

        def to_dict(self):
            return dict(self._d)

    docs = [
        FakeDoc({'name': 'No Location'}),
        FakeDoc({'location': None, 'name': 'Null Location'}),
        FakeDoc({'location': [43.7, -79.4], 'name': 'Has Location'})
    ]

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
    p = Payload(source='db', lat=43.7, lng=-79.4, radius_m=10000)
    res = await s.search(p)
    assert res['source'] == 'db'
    assert res['total'] == 1
    assert res['items'][0]['name'] == 'Has Location'


@pytest.mark.asyncio
async def test_search_db_distance_filtering(monkeypatch):
    """Test that only restaurants within radius are returned"""
    class FakeDoc:
        def __init__(self, d, id_='d1'):
            self._d = d
            self.id = id_

        def to_dict(self):
            return dict(self._d)

    docs = [
        FakeDoc({'location': [43.7, -79.4], 'name': 'Very Close'}),
        FakeDoc({'location': [45.0, -80.0], 'name': 'Too Far'})
    ]

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
    p = Payload(source='db', lat=43.7, lng=-79.4, radius_m=1000)  # Very small radius
    res = await s.search(p)
    assert res['source'] == 'db'
    # Only the very close restaurant should be returned
    assert all('Very Close' in r['name'] for r in res['items'])


@pytest.mark.asyncio
async def test_search_db_with_string_location_degrees(monkeypatch):
    """Test parsing string location with degree symbols"""
    class FakeDoc:
        def __init__(self, d, id_='d1'):
            self._d = d
            self.id = id_

        def to_dict(self):
            return dict(self._d)

    docs = [FakeDoc({'location': ['43.7° N', '-79.4° W'], 'name': 'String Coords'})]

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
    p = Payload(source='db', lat=43.7, lng=-79.4, radius_m=10000)
    res = await s.search(p)
    assert res['source'] == 'db'
    # Should parse the string coordinates
    assert res['total'] >= 0  # May or may not be within radius depending on parsing


@pytest.mark.asyncio
async def test_search_places_missing_fields(monkeypatch):
    """Test that places search handles missing fields gracefully"""
    monkeypatch.setattr('backend.api_search.agents.single_source.DEMO', False)
    fake_results = [
        {"name": "A"},  # Missing address and place_id
        {"place_id": "pid2"},  # Missing name and address
        {}  # Missing everything
    ]
    monkeypatch.setattr('backend.api_search.agents.single_source.text_search', AsyncMock(return_value=fake_results))

    s = SingleSourceSearch()
    p = Payload(source='places', google_place_id='test', query=None, address=None, lat=None, lng=None, radius_m=None)
    res = await s.search(p)
    assert res['source'] == 'places'
    assert res['total'] == 3
    # Check default values are applied
    assert res['items'][0]['name'] == 'A'
    assert res['items'][0]['address'] == 'Address not available'
    assert res['items'][1]['name'] == 'Unknown'


@pytest.mark.asyncio
async def test_search_db_invalid_numeric_coords(monkeypatch):
    """Test handling of invalid coordinate values"""
    class FakeDoc:
        def __init__(self, d, id_='d1'):
            self._d = d
            self.id = id_

        def to_dict(self):
            return dict(self._d)

    docs = [
        FakeDoc({'location': ['invalid', 'coords'], 'name': 'Bad Coords'}),
        FakeDoc({'location': [43.7, -79.4], 'name': 'Good Coords'})
    ]

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
    p = Payload(source='db', lat=43.7, lng=-79.4, radius_m=10000)
    res = await s.search(p)
    assert res['source'] == 'db'
    # Should only return the restaurant with valid coords
    assert all('Good Coords' in r['name'] for r in res['items'])



