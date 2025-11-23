import sys
import os
import asyncio
from unittest.mock import MagicMock, patch
import datetime

# Add project root to path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..')))

import pytest
from backend.api_search.agents.rank_agent import RankAgentRunner


class GeoPointLike:
    def __init__(self, lat, lng):
        self.latitude = lat
        self.longitude = lng


def test_serialize_firestore_value_variants():
    with patch('backend.api_search.agents.rank_agent.AgentExecutor'):
        runner = RankAgentRunner(agent=MagicMock())

    # None
    assert runner._serialize_firestore_value(None) is None

    # GeoPoint-like
    gp = GeoPointLike(43.7, -79.4)
    assert runner._serialize_firestore_value(gp) == [43.7, -79.4]

    # datetime
    dt = datetime.datetime(2020, 1, 2, 3, 4, 5)
    iso = runner._serialize_firestore_value(dt)
    assert isinstance(iso, str) and iso.startswith('2020-01-02')

    # dict and list
    nested = {"a": gp, "b": [dt, None, 3]}
    s = runner._serialize_firestore_value(nested)
    assert isinstance(s, dict) and s['a'] == [43.7, -79.4]


def test_extract_place_ids_and_cleaning():
    with patch('backend.api_search.agents.rank_agent.AgentExecutor'):
        runner = RankAgentRunner(agent=MagicMock())

    restaurants = [
        {"place_id": "p1", "name": "One", "rating": 4.5, "extra": "x"},
        {"google_place_id": "p2", "name": "Two", "types": ["food"]},
    ]

    ids = runner._extract_place_ids(restaurants)
    assert ids == ["p1", "p2"]

    cleaned = runner._clean_restaurant_for_llm(restaurants[0])
    assert cleaned.get('name') == 'One'
    assert 'extra' not in cleaned


@pytest.mark.asyncio
async def test_run_fallback_archetype():
    # Ensure fallback path when archetype not found
    with patch('backend.api_search.agents.rank_agent.AgentExecutor'):
        runner = RankAgentRunner(agent=MagicMock())

    mock_db = [{"place_id": "1", "name": "A"}, {"place_id": "2", "name": "B"}]

    with patch('backend.api_search.agents.rank_agent.load_archetypes', return_value={}), \
         patch('backend.api_search.agents.rank_agent.asyncio.to_thread', side_effect=[mock_db, {"output": []}]):
        res = await runner.run(place_ids=["1", "2"], palate_archetype="Nope")

    assert res["total_restaurants"] == 2
    assert len(res["ranked_restaurants"]) == 2
    # Justifications should mention archetype not found fallback
    assert any('archetype' in j[0].lower() or 'Selected by order' in j[0] for j in [r['justification'] for r in res['ranked_restaurants']])
