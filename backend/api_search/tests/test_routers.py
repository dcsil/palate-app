import sys
import os
from unittest.mock import AsyncMock, MagicMock

# Add project root to path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..')))
from fastapi.testclient import TestClient
import pytest

# Ensure main's absolute import `from routers import health, agent_places` resolves
import importlib
import sys
_routers_pkg = importlib.import_module('backend.api_search.routers')
_routers_health = importlib.import_module('backend.api_search.routers.health')
# Ensure `models` and `deps` top-level names resolve to the package modules used in imports
_models_pkg = importlib.import_module('backend.api_search.models')
_models_requests = importlib.import_module('backend.api_search.models.requests')
_models_responses = importlib.import_module('backend.api_search.models.responses')
sys.modules['models'] = _models_pkg
sys.modules['models.requests'] = _models_requests
sys.modules['models.responses'] = _models_responses

_deps_mod = importlib.import_module('backend.api_search.deps')
sys.modules['deps'] = _deps_mod

_routers_agent_places = importlib.import_module('backend.api_search.routers.agent_places')
sys.modules['routers'] = _routers_pkg
sys.modules['routers.health'] = _routers_health
sys.modules['routers.agent_places'] = _routers_agent_places

from backend.api_search import main
from backend.api_search import deps


def test_health_endpoint():
    client = TestClient(main.app)
    r = client.get('/health')
    assert r.status_code == 200
    assert r.json() == {"ok": True}


def test_search_endpoint_overrides():
    # Create a fake service with async search
    class FakeSvc:
        async def search(self, payload):
            return {"source": "places", "total": 1, "items": [{"name": "X"}]}

    # Override the dependency used in the router
    main.app.dependency_overrides[deps.get_single_source_search] = lambda: FakeSvc()

    client = TestClient(main.app)
    body = {"query": "x", "source": "places"}
    r = client.post('/agent/search', json=body)
    assert r.status_code == 200
    data = r.json()
    assert data["source"] == "places"
    assert data["total"] == 1

    # Clean up override
    main.app.dependency_overrides.pop(deps.get_single_source_search, None)


def test_rank_endpoint_overrides():
    # Fake rank agent
    class FakeRank:
        async def run(self, place_ids, palate_archetype, user_data):
            return {"ranked_restaurants": [], "total_restaurants": 0}

    main.app.dependency_overrides[deps.get_rank_agent] = lambda: FakeRank()

    client = TestClient(main.app)
    body = {"place_ids": ["p1", "p2"], "palate_archetype": "Explorer", "user_data": None}
    r = client.post('/agent/rank', json=body)
    assert r.status_code == 200
    data = r.json()
    assert data["total_restaurants"] == 0

    main.app.dependency_overrides.pop(deps.get_rank_agent, None)
