import sys
import os
import asyncio

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import pytest

from places_service import PlacesService


def test_convert_price_level_values():
    s = PlacesService()
    assert s._convert_price_level('PRICE_LEVEL_FREE') == 0
    assert s._convert_price_level('PRICE_LEVEL_INEXPENSIVE') == 1
    assert s._convert_price_level('PRICE_LEVEL_MODERATE') == 2
    assert s._convert_price_level('PRICE_LEVEL_EXPENSIVE') == 3
    assert s._convert_price_level('PRICE_LEVEL_VERY_EXPENSIVE') == 4
    assert s._convert_price_level(None) is None
    assert s._convert_price_level(2) == 2
    assert s._convert_price_level('UNKNOWN') is None


def test_calculate_distance_and_build_result():
    s = PlacesService()
    # sample place with displayName structure used in code
    place = {
        "id": "test123",
        "displayName": {"text": "Test Place"},
        "location": {"latitude": 10.0, "longitude": 20.0},
        "servesBreakfast": True,
    }

    # distance calculation
    dist = s._calculate_distance(place, 10.0, 20.0)
    assert dist == 0.0

    # build result
    result = s._build_search_result(place, ["http://img"], dist)
    assert result["place_id"] == "test123"
    assert result["name"] == "Test Place"
    assert result["photos"] == ["http://img"]
    assert "service_options" in result and "serves" in result["service_options"]


def test_get_restaurant_details_requires_api_key():
    s = PlacesService()
    s.api_key = None

    with pytest.raises(ValueError):
        asyncio.run(s.get_restaurant_details("p1"))
