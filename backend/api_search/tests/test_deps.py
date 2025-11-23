import sys
import os
from unittest.mock import patch, MagicMock

# Add project root to path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..')))
# Note: do not add the package dir here to avoid confusing relative imports

import pytest
import types

# Prepare fake top-level 'agents' package to satisfy absolute imports inside deps
agents_pkg = types.ModuleType('agents')
agents_single = types.ModuleType('agents.single_source')
class _FakeSingleSource:
    def search(self, payload=None):
        return {"ok": True}
setattr(agents_single, 'SingleSourceSearch', _FakeSingleSource)
agents_rank = types.ModuleType('agents.rank_agent')
setattr(agents_rank, 'build_rank_agent', lambda: 'BUILT')
import sys
sys.modules['agents'] = agents_pkg
sys.modules['agents.single_source'] = agents_single
sys.modules['agents.rank_agent'] = agents_rank

from backend.api_search import deps


def test_get_single_source_search_instance():
    svc = deps.get_single_source_search()
    # Should return an object with a `search` callable
    assert hasattr(svc, 'search')


def test_get_rank_agent_calls_builder():
    with patch('backend.api_search.deps.build_rank_agent', return_value='BUILT'):
        val = deps.get_rank_agent()
        assert val == 'BUILT'
