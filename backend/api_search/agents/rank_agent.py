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
    
    system_prompt = """You are a restaurant ranking agent. Your job is to rank restaurants based on a user's taste vector, explicit preferences, and implicit user data.

    Instructions:
    1. You will receive:
    - A list of restaurant dictionaries (each with metadata like name, rating, images, amenities, etc.)
    - A taste vector: keywords/attributes the user explicitly cares about (e.g., ["cozy", "aesthetic", "student-friendly"])
    - Implicit user data: restaurants they have liked, saved, visited, and disliked

    2. Evaluate each restaurant by considering:
    - How well the restaurant matches the taste vector keywords
    - Patterns in the user's implicit data:
        * Similarities to restaurants they liked or saved
        * Contrast with restaurants they disliked
        * Restaurant types/attributes they have visited before
    - The metadata provided (images, amenities, ratings, services, etc.)
    - Overall fit for the user's preferences based on their complete history

    3. Return ONLY a JSON array of the top 5 restaurants. Each item must have:
    - "restaurant": the original restaurant dictionary (unchanged)
    - "justification": a short 2-3 sentence explanation combining why this restaurant matches the taste vector AND implicit user preferences

    4. Ensure the JSON is valid and contains exactly the structure above.

    Do not include any markdown, commentary, or explanation outside the JSON. Return only the JSON array.
    
    """

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
    
    async def run(self, restaurants: List[Dict[str, Any]], taste_vector: List[str], user_data: Dict[str, Any] = None) -> Dict[str, Any]:
        """
        Rank restaurants based on taste vector and implicit user data.
        
        Args:
            restaurants: List of restaurant dictionaries (output from single_source.py)
            taste_vector: List of keywords/attributes (e.g., ["cozy", "aesthetic", "student-friendly"])
            user_data: Dict with keys "likes", "saved", "visited", "disliked" (each containing list of restaurant dicts)
        
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
        
        if not taste_vector and not user_data:
            # If no taste vector and no user data, just return top 5 by distance/rating as fallback
            fallback = restaurants[:5]
            return {
                "ranked_restaurants": [
                    {"restaurant": r, "justification": "Selected by proximity"}
                    for r in fallback
                ],
                "total_restaurants": len(restaurants)
            }
        
        # Prepare user data context
        user_data_context = ""
        if user_data:
            user_data_context = f"""
                User's implicit restaurant data:
                - Liked restaurants: {json.dumps([{"name": r.get("name"), "category": r.get("category")} for r in user_data.get("likes", [])], default=str)}
                - Saved restaurants: {json.dumps([{"name": r.get("name"), "category": r.get("category")} for r in user_data.get("saved", [])], default=str)}
                - Visited restaurants: {json.dumps([{"name": r.get("name"), "category": r.get("category")} for r in user_data.get("visited", [])], default=str)}
                - Disliked restaurants: {json.dumps([{"name": r.get("name"), "category": r.get("category")} for r in user_data.get("disliked", [])], default=str)}
            """
        
        # Build input text for the agent
        input_txt = f"""
            User's taste vector: {json.dumps(taste_vector)}
            {user_data_context}
            Restaurants to rank:
            {json.dumps(restaurants, indent=2, default=str)}

            Rank the top 5 restaurants that best match the user's taste vector and implicit preferences. Consider all metadata provided and the user's history.
            Return ONLY a JSON array with "restaurant" and "justification" keys for each item.
        """
        
        try:
            # Run agent in a thread to avoid blocking
            result = await asyncio.to_thread(
                lambda: self.exec.invoke({"input": input_txt})
            )
            
            output = result.get("output", "")
            print(f"[DEBUG] Agent output type: {type(output)}")
            print(f"[DEBUG] Agent output preview: {str(output)[:500]}")
            
            # Parse JSON from output
            if isinstance(output, str):
                # Try to extract JSON array from response
                try:
                    # Look for JSON array pattern
                    import re
                    json_match = re.search(r'\[\s*\{.*\}\s*\]', output, re.DOTALL)
                    if json_match:
                        print(f"[DEBUG] Found JSON match, parsing...")
                        ranked = json.loads(json_match.group())
                    else:
                        print(f"[DEBUG] No JSON match found, trying direct parse...")
                        ranked = json.loads(output)
                    print(f"[DEBUG] Successfully parsed JSON with {len(ranked)} items")
                except (json.JSONDecodeError, ValueError) as e:
                    print(f"[DEBUG] JSON parse failed: {e}")
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
            import traceback
            print(f"[ERROR] Exception in rank agent: {e}")
            print(traceback.format_exc())
            # Fallback on any error: return top 5 by distance
            return {
                "ranked_restaurants": [
                    {"restaurant": r, "justification": f"Fallback ranking (error: {str(e)[:50]})"}
                    for r in restaurants[:5]
                ],
                "total_restaurants": len(restaurants)
            }
