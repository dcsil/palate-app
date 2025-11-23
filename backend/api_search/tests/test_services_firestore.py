import sys
import os

# Add project root to path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..')))

from unittest.mock import MagicMock, patch
import pytest

from backend.api_search.services import firestore


class FakeDoc:
    def __init__(self, d, id_="doc"):
        self._d = d
        self.id = id_

    def to_dict(self):
        return dict(self._d)


class FakeQuery:
    def __init__(self, docs):
        self._docs = docs

    def stream(self):
        return iter(self._docs)


class FakeCollection:
    def __init__(self, docs):
        self._docs = docs

    def where(self, *args, **kwargs):
        return FakeQuery(self._docs)


class FakeDB:
    def __init__(self, docs):
        self._docs = docs

    def collection(self, name):
        return FakeCollection(self._docs)


def test_restaurant_by_place_ids_and_get_restaurants():
    docs = [FakeDoc({"place_id": "a", "name": "A"}), FakeDoc({"place_id": "b", "name": "B"})]
    fake_db = FakeDB(docs)

    with patch('backend.api_search.services.firestore.db', return_value=fake_db):
        found = firestore.restaurant_by_place_ids(["a", "b"])
        assert found == {"a", "b"}

        restaurants = firestore.get_restaurants_by_place_ids(["a", "b"])
        assert isinstance(restaurants, list)
        assert any(r["place_id"] == "a" for r in restaurants)
