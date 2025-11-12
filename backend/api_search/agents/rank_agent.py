"""
Rank Agent: LangChain-based agent that ranks restaurants by taste vector and metadata.
Uses GPT-4o-mini to evaluate restaurants against user taste preferences.
"""
import asyncio
import json
from typing import Dict, Any, List
from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain.agents import AgentExecutor, create_openai_tools_agent


def build_rank_agent() -> "RankAgentRunner":
    """Build and return a RankAgentRunner instance."""
    tools = []  # No external tools needed for ranking; LLM uses reasoning only
    
    llm = ChatOpenAI(model="gpt-4o-mini", temperature=0)
    
    system_prompt = """You are a restaurant ranking agent. Your job is to rank restaurants based on a user's taste vector (keywords/attributes they care about).

Instructions:
1. You will receive:
   - A list of restaurant dictionaries (each with metadata like name, rating, images, amenities, etc.)
   - A taste vector: a list of keywords/attributes the user cares about (e.g., ["cozy", "aesthetic", "student-friendly"])

2. Evaluate each restaurant by considering:
   - How well the restaurant matches the taste vector keywords
   - The metadata provided (images, amenities, ratings, services, etc.)
   - The restaurant's overall fit for the user's preferences

3. Return ONLY a JSON array of the top 5 restaurants. Each item must have:
   - "restaurant": the original restaurant dictionary (unchanged)
   - "justification": a short 1-2 sentence explanation of why this restaurant matches the taste vector

4. Ensure the JSON is valid and contains exactly the structure above.

Do not include any markdown, commentary, or explanation outside the JSON. Return only the JSON array."""

    prompt = ChatPromptTemplate.from_messages([
        ("system", system_prompt),
        ("human", "{input}"),
        MessagesPlaceholder(variable_name="agent_scratchpad")
    ])
    
    agent = create_openai_tools_agent(llm, tools, prompt)
    return RankAgentRunner(agent)


class RankAgentRunner:
    def __init__(self, agent):
        self.exec = AgentExecutor(agent=agent, tools=[], verbose=False)
    
    async def run(self, restaurants: List[Dict[str, Any]], taste_vector: List[str]) -> Dict[str, Any]:
        """
        Rank restaurants based on taste vector.
        
        Args:
            restaurants: List of restaurant dictionaries (output from single_source.py)
            taste_vector: List of keywords/attributes (e.g., ["cozy", "aesthetic", "student-friendly"])
        
        Returns:
            {
                "ranked_restaurants": [
                    {
                        "restaurant": {...original dict...},
                        "justification": "Why this restaurant matches..."
                    },
                    ...
                ],
                "total_restaurants": int
            }
        """
        if not restaurants:
            return {"ranked_restaurants": [], "total_restaurants": 0}
        
        if not taste_vector:
            # If no taste vector, just return top 5 by distance/rating as fallback
            fallback = restaurants[:5]
            return {
                "ranked_restaurants": [
                    {"restaurant": r, "justification": "Selected by proximity"}
                    for r in fallback
                ],
                "total_restaurants": len(restaurants)
            }
        
        # Build input text for the agent
        input_txt = f"""
User's taste vector: {json.dumps(taste_vector)}

Restaurants to rank:
{json.dumps(restaurants, indent=2, default=str)}

Rank the top 5 restaurants that best match the user's taste vector. Consider all metadata provided.
Return ONLY a JSON array with "restaurant" and "justification" keys for each item.
"""
        
        try:
            # Run agent in a thread to avoid blocking
            result = await asyncio.to_thread(
                lambda: self.exec.invoke({"input": input_txt})
            )
            
            output = result["output"]
            
            # Parse JSON from output
            if isinstance(output, str):
                # Try to extract JSON array from response
                try:
                    # Look for JSON array pattern
                    import re
                    json_match = re.search(r'\[.*\]', output, re.DOTALL)
                    if json_match:
                        ranked = json.loads(json_match.group())
                    else:
                        ranked = json.loads(output)
                except (json.JSONDecodeError, ValueError):
                    # Fallback: return top 5 restaurants as-is
                    ranked = [
                        {"restaurant": r, "justification": "Could not rank; returning by proximity"}
                        for r in restaurants[:5]
                    ]
            else:
                ranked = output
            
            # Ensure we have at most 5 items
            ranked = ranked[:5] if isinstance(ranked, list) else [ranked]
            
            # Validate structure
            for item in ranked:
                if "restaurant" not in item:
                    item["restaurant"] = {}
                if "justification" not in item:
                    item["justification"] = ""
            
            return {
                "ranked_restaurants": ranked,
                "total_restaurants": len(restaurants)
            }
            
        except Exception as e:
            # Fallback on any error: return top 5 by distance
            return {
                "ranked_restaurants": [
                    {"restaurant": r, "justification": f"Fallback ranking (error: {str(e)[:50]})"}
                    for r in restaurants[:5]
                ],
                "total_restaurants": len(restaurants)
            }

