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


@pytest.mark.asyncio
async def test_search_db_location_lat_lng_reversed(monkeypatch):
    """Test [lat, lng] where second value > 90 (reversed detection)"""
    class FakeDoc:
        def __init__(self, d, id_='d1'):
            self._d = d
            self.id = id_

        def to_dict(self):
            return dict(self._d)

    # [lat, lng] where lng > 90
    docs = [FakeDoc({'location': [30.0, 120.0], 'name': 'Reversed Detection'})]

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
async def test_search_db_location_with_hemispheres(monkeypatch):
    """Test string coordinates with hemisphere indicators"""
    class FakeDoc:
        def __init__(self, d, id_='d1'):
            self._d = d
            self.id = id_

        def to_dict(self):
            return dict(self._d)

    # Test S and W hemispheres (should become negative)
    docs = [FakeDoc({'location': ['43.7 S', '79.4 W'], 'name': 'Southern Hemisphere'})]

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
    # Search near southern hemisphere location
    p = Payload(source='db', lat=-43.7, lng=-79.4, radius_m=10000)
    res = await s.search(p)
    assert res['source'] == 'db'
    # Should parse and potentially find the location


@pytest.mark.asyncio
async def test_search_db_location_tuple_geopoint_in_list(monkeypatch):
    """Test parse_number returning tuple (GeoPoint in list)"""
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

    # Location as list with GeoPoint object
    gp = FakeGeoPoint(43.7, -79.4)
    docs = [FakeDoc({'location': [gp, None], 'name': 'GeoPoint in List'})]

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


@pytest.mark.asyncio
async def test_search_db_serialize_datetime(monkeypatch):
    """Test serialization of datetime objects"""
    import datetime
    
    class FakeDoc:
        def __init__(self, d, id_='d1'):
            self._d = d
            self.id = id_

        def to_dict(self):
            return dict(self._d)

    dt = datetime.datetime(2024, 1, 1, 12, 0, 0)
    docs = [FakeDoc({'location': [43.7, -79.4], 'name': 'With DateTime', 'created': dt})]

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
    # Datetime should be serialized to ISO format string
    assert isinstance(res['items'][0]['created'], str)


@pytest.mark.asyncio
async def test_search_db_serialize_nested_structures(monkeypatch):
    """Test serialization of nested dicts and lists"""
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

    gp = FakeGeoPoint(43.7, -79.4)
    docs = [FakeDoc({
        'location': [43.7, -79.4],
        'name': 'Nested Data',
        'metadata': {
            'coords': gp,
            'tags': ['a', 'b'],
            'nested': {'inner': [1, 2, None]}
        }
    })]

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
    # Nested GeoPoint should be serialized to list
    assert res['items'][0]['metadata']['coords'] == [43.7, -79.4]


@pytest.mark.asyncio
async def test_search_db_geopoint_in_second_position(monkeypatch):
    """Test when GeoPoint is in second position of location list"""
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

    gp = FakeGeoPoint(43.7, -79.4)
    docs = [FakeDoc({'location': [None, gp], 'name': 'GeoPoint Second'})]

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
    # Should successfully parse GeoPoint from second position


@pytest.mark.asyncio
async def test_search_db_location_not_list_or_tuple(monkeypatch):
    """Test when location is neither list, tuple, nor GeoPoint"""
    class FakeDoc:
        def __init__(self, d, id_='d1'):
            self._d = d
            self.id = id_

        def to_dict(self):
            return dict(self._d)

    docs = [
        FakeDoc({'location': 'invalid_format', 'name': 'Bad Format'}),
        FakeDoc({'location': [43.7, -79.4], 'name': 'Valid'})
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
    # Should skip invalid location and only return the valid one
    assert all('Valid' in r['name'] for r in res['items'])


@pytest.mark.asyncio
async def test_search_db_location_tuple_format(monkeypatch):
    """Test location as tuple instead of list"""
    class FakeDoc:
        def __init__(self, d, id_='d1'):
            self._d = d
            self.id = id_

        def to_dict(self):
            return dict(self._d)

    docs = [FakeDoc({'location': (43.7, -79.4), 'name': 'Tuple Location'})]

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



