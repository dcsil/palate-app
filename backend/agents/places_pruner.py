import asyncio
from typing import Dict, Any
from langchain_core.messages import HumanMessage
from langchain_openai import ChatOpenAI   # or your preferred LLM
from langchain.agents import AgentExecutor, create_openai_tools_agent
from langchain_core.prompts import ChatPromptTemplate
from .tools_google import places_text_search_tool
from .tools_db import db_filter_known_place_ids

SYSTEM = """You help find restaurants using Google Places then prune to those present in our database.
Steps:
1) Use places_text_search with the user's query to get candidates.
2) From those candidates collect their place_id values and call db_filter_known_place_ids.
3) Return 'kept' = candidates whose place_id is in DB; 'dropped' = the rest.
Always return JSON with fields kept, dropped, total_candidates.
"""

def build_places_pruner_agent(model: str = "gpt-4o-mini") -> "AgentRunner":
    tools = [places_text_search_tool, db_filter_known_place_ids]
    llm = ChatOpenAI(model=model)  # small + cheap works; or any compatible functions model
    prompt = ChatPromptTemplate.from_messages([("system", SYSTEM), ("human", "{input}")])
    agent = create_openai_tools_agent(llm, tools, prompt)
    return AgentRunner(agent)

class AgentRunner:
    def __init__(self, agent): self.exec = AgentExecutor(agent=agent, tools=[places_text_search_tool, db_filter_known_place_ids], verbose=False)
    async def run(self, payload) -> Dict[str, Any]:
        q = payload.google_place_id or payload.query or (payload.address or "")
        input_txt = f"query='{q}', lat={payload.lat}, lng={payload.lng}, radius_m={payload.radius_m}"
        result = await self.exec.ainvoke({"input": input_txt})
        # Ensure schema compliance (LLM already instructed, but we guard)
        out = result["output"]
        if isinstance(out, str):
            # Best-effort parse; in practice, you may JSON-dump within tools and pass through
            import json
            out = json.loads(out)
        out["total_candidates"] = out.get("total_candidates") or (len(out.get("kept", [])) + len(out.get("dropped", [])))
        return out
