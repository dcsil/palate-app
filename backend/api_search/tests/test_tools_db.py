import sys
import os

# Add project root to the Python path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..')))

import pytest
from unittest.mock import patch, MagicMock
from backend.api_search.agents.tools_db import db_filter_known_place_ids

@patch('backend.api_search.agents.tools_db.restaurant_by_place_ids')
def test_db_filter_known_place_ids(mock_restaurant_by_place_ids):
    """
    Tests the db_filter_known_place_ids tool.
    """
    # Define the mock return value for the patched function
    known_ids = ["id1", "id3"]
    mock_restaurant_by_place_ids.return_value = known_ids
    
    # Input list of place_ids to filter
    input_ids = ["id1", "id2", "id3", "id4"]
    
    # Call the tool's function directly
    result = db_filter_known_place_ids.func(place_ids=input_ids)
    
    # Assert that the patched function was called correctly
    mock_restaurant_by_place_ids.assert_called_once_with(input_ids)
    
    # Assert that the result is the list of known IDs
    assert result == known_ids
