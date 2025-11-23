import sys
import os

# Add project root to the Python path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..')))

import asyncio
from unittest.mock import MagicMock, patch, AsyncMock
import pytest
from langchain.agents import AgentExecutor
from backend.api_search.agents.rank_agent import RankAgentRunner, build_rank_agent, load_archetypes
from langchain.agents import AgentExecutor


@pytest.fixture
def mock_input_data():
    """Provides mock input for the rank agent runner."""
    return {
        "place_ids": ["1", "2"],
        "palate_archetype": "Explorer",
        "user_data": {
            "likes": [{"name": "Liked Place", "category": "Italian"}],
            "saved": [],
            "visited": [],
            "disliked": [],
        },
    }

@pytest.fixture
def mock_db_restaurants():
    """Mocks the restaurant data returned from Firestore."""
    return [
        {"place_id": "1", "name": "Pizza Place A", "rating": 4.5},
        {"place_id": "2", "name": "Sushi Place B", "rating": 4.8},
    ]

@pytest.fixture
def mock_llm_output():
    """Mocks the JSON output from the LLM."""
    return [
        {"place_id": "2", "justification": ["Great for adventurous eaters."]},
        {"place_id": "1", "justification": ["Classic, but with a unique twist."]},
    ]

@patch('backend.api_search.agents.rank_agent.ChatOpenAI')
def test_build_rank_agent(mock_chat_openai):
    """Tests if the rank agent runner is built correctly."""
    mock_chat_openai.return_value = MagicMock()
    runner = build_rank_agent()
    assert runner is not None
    assert isinstance(runner, RankAgentRunner)
    # The executor should be an AgentExecutor instance
    assert isinstance(runner.exec, AgentExecutor)


@pytest.mark.asyncio
@patch('backend.api_search.agents.rank_agent.asyncio.to_thread')
@patch('backend.api_search.agents.rank_agent.load_archetypes')
async def test_rank_agent_runner_run(
    mock_load_archetypes,
    mock_asyncio_to_thread,
    mock_input_data,
    mock_db_restaurants,
    mock_llm_output,
):
    """Tests the full run method of the RankAgentRunner."""
    # Mock archetype loading
    mock_load_archetypes.return_value = {
        "Explorer": {"name": "Explorer", "definition": "Loves trying new things."}
    }

    # Mock the agent executor and its response
    # The agent needs to be a valid Runnable, so we can't just pass a MagicMock.
    # We create a mock agent that has an invoke method.
    mock_agent = MagicMock()
    mock_agent.invoke.return_value = {"output": mock_llm_output}
    
    # We need to mock the AgentExecutor, not the agent itself
    with patch('backend.api_search.agents.rank_agent.AgentExecutor') as mock_agent_executor_class:
        mock_executor_instance = mock_agent_executor_class.return_value
        mock_executor_instance.invoke.return_value = {"output": mock_llm_output}

        # The runner is now initialized with the agent, so we build it first
        runner = RankAgentRunner(agent=mock_agent)

        # Mock the database call within asyncio.to_thread
        # The first call is get_restaurants_by_place_ids
        # The second call is the agent invocation
        mock_asyncio_to_thread.side_effect = [
            mock_db_restaurants,
            {"output": mock_llm_output}
        ]

        # Run the agent
        result = await runner.run(**mock_input_data)

        # Assertions
        assert mock_asyncio_to_thread.call_count == 2
        
        # Check the final output structure
        assert "ranked_restaurants" in result
        assert "total_restaurants" in result
        assert result["total_restaurants"] == 2
        assert len(result["ranked_restaurants"]) == 2

        # Check that both expected place_ids are present and justifications included
        place_ids = {r["restaurant"]["place_id"] for r in result["ranked_restaurants"]}
        assert place_ids == {"1", "2"}

        all_justifications = [j for r in result["ranked_restaurants"] for j in r["justification"]]
        assert "Great for adventurous eaters." in all_justifications
        assert "Classic, but with a unique twist." in all_justifications

@pytest.mark.asyncio
async def test_rank_agent_runner_empty_place_ids():
    """Tests the runner with an empty list of place_ids."""
    # We need to provide a valid agent to the constructor
    with patch('backend.api_search.agents.rank_agent.AgentExecutor'):
        runner = RankAgentRunner(agent=MagicMock())
        result = await runner.run(place_ids=[], palate_archetype="Explorer")
        assert result["ranked_restaurants"] == []
        assert result["total_restaurants"] == 0


def test_load_archetypes():
    """Tests if archetypes are loaded and parsed correctly."""
    archetypes = load_archetypes()
    assert isinstance(archetypes, dict)
    assert "Explorer" in archetypes
    assert "name" in archetypes["Explorer"]
    assert archetypes["Explorer"]["name"] == "Explorer"
