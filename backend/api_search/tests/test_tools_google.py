import sys
import os

# Add project root to the Python path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..')))

import asyncio
from unittest.mock import patch, MagicMock, AsyncMock
import pytest
from backend.api_search.agents.tools_google import places_text_search_tool

@pytest.mark.asyncio
@patch('backend.api_search.agents.tools_google.DEMO_MODE', True)
async def test_places_text_search_tool_demo_mode():
    """
    Tests that the tool returns a mock response when DEMO_MODE is True.
    """
    with patch('backend.api_search.agents.tools_google.text_search', new_callable=AsyncMock) as mock_text_search:
        result = await places_text_search_tool.ainvoke({"query": "test query"})
        
        mock_text_search.assert_not_awaited()
        
        assert isinstance(result, list)
        assert len(result) > 0
        assert result[0]["name"] == "Sushi Kaji"

@pytest.mark.asyncio
@patch('backend.api_search.agents.tools_google.DEMO_MODE', False)
async def test_places_text_search_tool_live_mode():
    """
    Tests that the tool calls the text_search function when DEMO_MODE is False.
    """
    with patch('backend.api_search.agents.tools_google.text_search', new_callable=AsyncMock) as mock_text_search:
        mock_response = [
            {
                "name": "Live Restaurant",
                "formatted_address": "123 Live St",
                "place_id": "live_place_1"
            }
        ]
        mock_text_search.return_value = mock_response

        result = await places_text_search_tool.ainvoke(
            {"query": "live query", "lat": 10.0, "lng": 20.0, "radius_m": 500}
        )
        # text_search is called with positional args in the implementation
        mock_text_search.assert_awaited_once_with('live query', 10.0, 20.0, 500)

        assert result == [
            {
                "name": "Live Restaurant",
                "address": "123 Live St",
                "place_id": "live_place_1"
            }
        ]
