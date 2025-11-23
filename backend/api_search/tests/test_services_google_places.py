import sys
import os

# Add project root to path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..')))

import asyncio
from unittest.mock import patch

import pytest

from backend.api_search.services.google_places import text_search


class FakeResponse:
    def __init__(self, results):
        self._results = results

    def raise_for_status(self):
        return None

    def json(self):
        return {"results": self._results}


class FakeAsyncClient:
    def __init__(self, resp):
        self._resp = resp

    async def __aenter__(self):
        return self

    async def __aexit__(self, exc_type, exc, tb):
        return False

    async def get(self, url, params=None):
        return self._resp


@pytest.mark.asyncio
async def test_text_search_returns_results(monkeypatch):
    fake_results = [{"name": "R1"}, {"name": "R2"}]
    fake_resp = FakeResponse(fake_results)

    # Patch httpx.AsyncClient used in the module to return our fake client
    monkeypatch.setattr('backend.api_search.services.google_places.httpx.AsyncClient', lambda *a, **k: FakeAsyncClient(fake_resp))

    res = await text_search("pizza", lat=1.0, lng=2.0, radius_m=500)
    assert isinstance(res, list)
    assert res[0]["name"] == "R1"
