from backend.api_search.agents.single_source import SingleSourceSearch
from backend.api_search.agents.rank_agent import build_rank_agent

def get_single_source_search():
    return SingleSourceSearch()

def get_rank_agent():
    return build_rank_agent()
