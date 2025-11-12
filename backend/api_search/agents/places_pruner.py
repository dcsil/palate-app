import asyncio
from typing import Dict, Any
from langchain_core.messages import HumanMessage
from langchain_openai import ChatOpenAI   # or your preferred LLM
# from langchain_community.chat_models import ChatOllama
from langchain.agents import AgentExecutor, create_openai_tools_agent
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from .tools_google import places_text_search_tool
from .tools_db import db_filter_known_place_ids

SYSTEM = """You help find restaurants using Google Places then prune to those present in our database.
Use the tools exactly as needed:
1) Call places_text_search to get candidates (name, address, place_id).
2) Collect their place_id values and call db_filter_known_place_ids(place_ids) to see which exist.
3) Return ONLY a JSON object with keys: kept, dropped, total_candidates.
 - kept = candidates whose place_id is in DB; each item must include: name, address, google_place_id, in_database:true
 - dropped = others; each item must include: name, address, google_place_id, in_database:false
No commentary, no markdown. Only raw JSON on the final answer.
"""

def build_places_pruner_agent(model: str = "gpt-4o-mini") -> "AgentRunner":
    tools = [places_text_search_tool, db_filter_known_place_ids]

    llm = ChatOpenAI(model="gpt-4o-mini")
    
    prompt = ChatPromptTemplate.from_messages([
        ("system", SYSTEM), 
        ("human", "{input}"),
        MessagesPlaceholder(variable_name="agent_scratchpad")
        ])
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
