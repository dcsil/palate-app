"""
Rank Agent: LangChain-based agent that ranks restaurants by palate archetype and metadata.
Uses GPT-4o-mini to evaluate restaurants against user palate archetype preferences.
"""
import asyncio
import json
import os
from pathlib import Path
from typing import Dict, Any, List, Optional
from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain.agents import AgentExecutor, create_openai_tools_agent
from langchain_core.callbacks import BaseCallbackHandler
from ..services.firestore import get_restaurants_by_place_ids


class TokenUsageCallback(BaseCallbackHandler):
    """Callback to track token usage from LLM calls."""
    def __init__(self):
        self.total_input_tokens = 0
        self.total_output_tokens = 0
        self.call_count = 0
    
    def on_llm_end(self, response, **kwargs):
        """Called when LLM finishes."""
        self.call_count += 1
        
        # Try multiple ways to get token usage
        token_usage = None
        
        # Method 1: LLMResult.llm_output (most common for LangChain)
        if hasattr(response, "llm_output") and response.llm_output:
            llm_output = response.llm_output
            if isinstance(llm_output, dict) and "token_usage" in llm_output:
                token_usage = llm_output["token_usage"]
        
        # Method 2: Check generations in LLMResult - look for usage_metadata (newer LangChain) or token_usage (older)
        if not token_usage and hasattr(response, "generations") and response.generations:
            print(f"[Token Callback] Checking {len(response.generations)} generation lists")
            for idx, generation_list in enumerate(response.generations):
                print(f"[Token Callback] Generation list {idx} has {len(generation_list)} generations")
                for gen_idx, generation in enumerate(generation_list):
                    print(f"[Token Callback] Checking generation {gen_idx}, type: {type(generation)}")
                    print(f"[Token Callback] Has usage_metadata attr: {hasattr(generation, 'usage_metadata')}")
                    
                    # Check usage_metadata (newer LangChain versions) - this is the primary method
                    if hasattr(generation, "usage_metadata"):
                        usage_meta = generation.usage_metadata
                        print(f"[Token Callback] usage_metadata value: {usage_meta}, type: {type(usage_meta)}")
                        if usage_meta is not None:  # Check if it's not None
                            # Handle both dict and object formats
                            if isinstance(usage_meta, dict):
                                input_tokens = usage_meta.get("input_tokens", 0)
                                output_tokens = usage_meta.get("output_tokens", 0)
                                print(f"[Token Callback] Extracted from dict - input: {input_tokens}, output: {output_tokens}")
                                if input_tokens > 0 or output_tokens > 0:  # Only create if we have actual values
                                    token_usage = {
                                        "prompt_tokens": input_tokens,
                                        "completion_tokens": output_tokens,
                                        "input_tokens": input_tokens,
                                        "output_tokens": output_tokens,
                                    }
                                    print(f"[Token Callback] Created token_usage: {token_usage}")
                                    break
                            else:
                                # Object format - try to get attributes
                                input_tokens = getattr(usage_meta, "input_tokens", None)
                                output_tokens = getattr(usage_meta, "output_tokens", None)
                                print(f"[Token Callback] Extracted from object - input: {input_tokens}, output: {output_tokens}")
                                if input_tokens is not None or output_tokens is not None:
                                    token_usage = {
                                        "prompt_tokens": input_tokens or 0,
                                        "completion_tokens": output_tokens or 0,
                                        "input_tokens": input_tokens or 0,
                                        "output_tokens": output_tokens or 0,
                                    }
                                    print(f"[Token Callback] Created token_usage: {token_usage}")
                                    break
                        else:
                            print(f"[Token Callback] usage_metadata is None")
                    else:
                        print(f"[Token Callback] generation does not have usage_metadata attribute")
                if token_usage:
                    break
                    # Check response_metadata for token_usage (older format)
                    if hasattr(generation, "response_metadata") and generation.response_metadata:
                        if "token_usage" in generation.response_metadata:
                            token_usage = generation.response_metadata["token_usage"]
                            break
                    # Check generation_info (legacy)
                    if hasattr(generation, "generation_info") and generation.generation_info:
                        if "token_usage" in generation.generation_info:
                            token_usage = generation.generation_info["token_usage"]
                            break
        
        # Method 3: response_metadata attribute
        if not token_usage and hasattr(response, "response_metadata"):
            metadata = response.response_metadata
            if metadata and "token_usage" in metadata:
                token_usage = metadata["token_usage"]
        
        # Method 4: llm_output in kwargs
        if not token_usage and "llm_output" in kwargs:
            llm_output = kwargs["llm_output"]
            if isinstance(llm_output, dict) and "token_usage" in llm_output:
                token_usage = llm_output["token_usage"]
        
        # Method 5: Check if response is a dict
        if not token_usage and isinstance(response, dict):
            if "llm_output" in response and isinstance(response["llm_output"], dict):
                if "token_usage" in response["llm_output"]:
                    token_usage = response["llm_output"]["token_usage"]
            if not token_usage and "response_metadata" in response:
                metadata = response["response_metadata"]
                if metadata and "token_usage" in metadata:
                    token_usage = metadata["token_usage"]
            if not token_usage and "token_usage" in response:
                token_usage = response["token_usage"]
        
        # Method 6: Check kwargs directly
        if not token_usage and "token_usage" in kwargs:
            token_usage = kwargs["token_usage"]
        
        if token_usage:
            print(f"[Token Callback] Found token_usage: {token_usage}")
            self.total_input_tokens += token_usage.get("prompt_tokens", 0) or token_usage.get("input_tokens", 0) or 0
            self.total_output_tokens += token_usage.get("completion_tokens", 0) or token_usage.get("output_tokens", 0) or 0
        else:
            # Debug: print what we actually have
            if hasattr(response, "llm_output"):
                print(f"[Token Callback] llm_output: {response.llm_output}")
            if hasattr(response, "generations"):
                print(f"[Token Callback] generations: {response.generations}")
            print(f"[Token Callback] No token_usage found in response")
    
    def on_llm_start(self, serialized, prompts, **kwargs):
        """Called when LLM starts."""
        print(f"[Token Callback] on_llm_start called")


def load_archetypes() -> Dict[str, Dict[str, Any]]:
    """Load archetypes from archetypes.json and return as a dictionary keyed by name."""
    # Get the directory where this file is located
    current_dir = Path(__file__).parent.parent
    archetypes_path = current_dir / "archetypes.json"
    
    with open(archetypes_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    # Convert list to dictionary keyed by name
    archetypes_dict = {}
    for archetype in data.get("archetypes", []):
        archetypes_dict[archetype["name"]] = archetype
    
    return archetypes_dict


def build_rank_agent() -> "RankAgentRunner":
    """Build and return a RankAgentRunner instance."""
    tools = []  # No external tools needed for ranking; LLM uses reasoning only
    
    llm = ChatOpenAI(model="gpt-4o-mini", temperature=0)
    
    system_prompt = """You are a restaurant ranking agent. Your job is to rank restaurants based on a user's palate archetype, explicit preferences, and implicit user data.

    Instructions:
    1. You will receive:
    - A list of restaurant dictionaries (each with metadata like name, rating, images, amenities, etc.)
    - A palate archetype: the user's dining personality type (e.g., "Explorer", "Purist", "Social Curator", "Trend Seeker", "Conformist", "Aestheticist") with its definition, core motivations, and behavioral signals
    - Implicit user data: restaurants they have liked, saved, visited, and disliked

    2. Evaluate each restaurant by considering:
    - How well the restaurant aligns with the user's palate archetype (considering the archetype's definition, core motivations, and signals)
    - Patterns in the user's implicit data:
        * Similarities to restaurants they liked or saved
        * Contrast with restaurants they disliked
        * Restaurant types/attributes they have visited before
    - The metadata provided (images, amenities, ratings, services, etc.)
    - Overall fit for the user's preferences based on their complete history and archetype

    3. Return ONLY a JSON array of the top 5 restaurants. Each item must have:
    - "place_id": the restaurant's place_id (string) - this is the unique identifier for the restaurant
    - "justification": an ARRAY of 2-3 strings (bullet points) explaining why this restaurant matches the user's palate archetype AND implicit user preferences. Each string should be a separate bullet point. It will be displayed directly to the user, so make it easy to understand and engaging. Example: ["Point 1", "Point 2", "Point 3"]
    
    IMPORTANT: Only return place_id and justification. Do NOT return the full restaurant dictionary to save tokens.

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
        self.exec = AgentExecutor(agent=agent, tools=[], verbose=False, return_intermediate_steps=True)
        self._archetypes = None
        self._token_callback = TokenUsageCallback()
    
    def _get_archetypes(self) -> Dict[str, Dict[str, Any]]:
        """Lazy load archetypes."""
        if self._archetypes is None:
            self._archetypes = load_archetypes()
        return self._archetypes
    
    def _serialize_firestore_value(self, value: Any) -> Any:
        """
        Recursively convert Firestore types to JSON-safe equivalents.
        Handles GeoPoint, Timestamp, and other non-serializable types.
        """
        if value is None:
            return None
        
        # GeoPoint -> [lat, lng]
        if hasattr(value, "latitude") and hasattr(value, "longitude"):
            return [value.latitude, value.longitude]
        
        # Timestamp/datetime -> ISO string
        if hasattr(value, "isoformat"):
            return value.isoformat()
        
        # Recursively handle dicts
        if isinstance(value, dict):
            return {k: self._serialize_firestore_value(v) for k, v in value.items()}
        
        # Recursively handle lists and tuples
        if isinstance(value, (list, tuple)):
            return [self._serialize_firestore_value(v) for v in value]
        
        # Return as-is for primitives (str, int, float, bool)
        return value
    
    def _serialize_restaurant(self, restaurant: Dict[str, Any]) -> Dict[str, Any]:
        """Serialize a restaurant dictionary, converting Firestore types to JSON-safe formats."""
        return self._serialize_firestore_value(restaurant)
    
    def _extract_place_ids(self, restaurants: List[Dict[str, Any]]) -> List[str]:
        """Extract place IDs from restaurant dictionaries. Checks both 'place_id' and 'google_place_id' fields."""
        place_ids = []
        for restaurant in restaurants:
            place_id = restaurant.get("place_id") or restaurant.get("google_place_id")
            if place_id:
                place_ids.append(place_id)
        return place_ids
    
    def _clean_restaurant_for_llm(self, restaurant: Dict[str, Any]) -> Dict[str, Any]:
        """
        Clean restaurant document to only include fields valuable for LLM ranking decisions.
        Removes internal metadata, links, and other non-essential fields.
        """
        # Fields valuable for LLM ranking
        valuable_fields = {
            "name",
            "category",
            "price_range",
            "user_rating_count",
            "rating",  # if exists
            "address",
            "google_types",
            "business_status",
            "accessibility_options",
            "place_id",
            "google_place_id",
            "phone_number",
            "live_music",
            # New fields
            "serves_beer",
            "serves_cocktails",
            "serves_wine",
            "outdoor_seating",
            "distance_meters",
            "good_for_groups",
            "good_for_watching_sports",
            "types",
        }
        
        cleaned = {}
        for key, value in restaurant.items():
            if key in valuable_fields:
                # Handle nested objects like accessibility_options
                if isinstance(value, dict):
                    cleaned[key] = value
                # Handle lists like google_types, types
                elif isinstance(value, list):
                    cleaned[key] = value
                # Handle primitives (including None values - fields might be null)
                else:
                    cleaned[key] = value
        
        return cleaned
    
    async def run(self, place_ids: List[str], palate_archetype: str, user_data: Dict[str, Any] = None) -> Dict[str, Any]:
        """
        Rank restaurants based on palate archetype and implicit user data.
        
        Args:
            place_ids: List of place IDs (Google Place IDs) to rank
            palate_archetype: String name of the user's palate archetype (e.g., "Explorer", "Purist", "Social Curator", "Trend Seeker", "Conformist", "Aestheticist")
            user_data: Dict with keys "likes", "saved", "visited", "disliked" (each containing list of restaurant dicts)
        
        Returns:
            {
                "ranked_restaurants": [
                    {
                        "restaurant": {...restaurant dict from database...},
                        "justification": "Why this restaurant matches..."
                    },
                    ...
                ],
                "total_restaurants": int
            }
        """
        if not place_ids:
            return {"ranked_restaurants": [], "total_restaurants": 0}
        
        # Step 1: Query database for full restaurant documents
        db_restaurants = await asyncio.to_thread(get_restaurants_by_place_ids, place_ids)
        
        if not db_restaurants:
            # If no restaurants found in DB, return empty result
            return {
                "ranked_restaurants": [],
                "total_restaurants": 0
            }
        
        # Step 2: Create mappings from place_id to restaurant data
        place_id_to_restaurant = {}  # Full restaurant dict from DB
        place_id_to_cleaned = {}  # Cleaned restaurant dict for LLM
        
        for db_restaurant in db_restaurants:
            place_id = db_restaurant.get("place_id") or db_restaurant.get("google_place_id")
            if place_id:
                place_id_to_restaurant[place_id] = db_restaurant
                cleaned = self._clean_restaurant_for_llm(db_restaurant)
                place_id_to_cleaned[place_id] = cleaned
        
        # Step 3: Create cleaned restaurant list matching input order
        cleaned_restaurants = []
        place_id_order = []  # Track order of place_ids for mapping back
        
        for place_id in place_ids:
            if place_id in place_id_to_cleaned:
                cleaned_restaurants.append(place_id_to_cleaned[place_id])
                place_id_order.append(place_id)
            # If place_id not in DB, skip it (or could add a placeholder)
        
        if not cleaned_restaurants:
            return {
                "ranked_restaurants": [],
                "total_restaurants": 0
            }
        
        # Load archetype information
        archetypes = self._get_archetypes()
        archetype_info = archetypes.get(palate_archetype)
        
        if not archetype_info:
            # If archetype not found, fallback to first 5 restaurants
            fallback_place_ids = place_id_order[:5]
            fallback_restaurants = []
            for pid in fallback_place_ids:
                restaurant = place_id_to_restaurant.get(pid, {})
                # Serialize Firestore types before returning
                serialized_restaurant = self._serialize_restaurant(restaurant)
                fallback_restaurants.append({
                    "restaurant": serialized_restaurant,
                    "justification": [f"Selected by order (archetype '{palate_archetype}' not found)"]
                })
            return {
                "ranked_restaurants": fallback_restaurants,
                "total_restaurants": len(cleaned_restaurants)
            }
        
        # Prepare archetype context - pass full JSON description
        archetype_context = f"""
            User's Palate Archetype (full description):
            {json.dumps(archetype_info, indent=2)}
        """
        
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
        
        # Build input text for the agent using cleaned restaurants
        input_txt = f"""
            {archetype_context}
            {user_data_context}
            Restaurants to rank:
            {json.dumps(cleaned_restaurants, indent=2, default=str)}

            Rank the top 5 restaurants that best match the user's palate archetype and implicit preferences. Consider all metadata provided and the user's history.
            Return ONLY a JSON array with "place_id" and "justification" keys for each item. Do NOT include the full restaurant dictionary.
        """
        
        try:
            # Reset token callback
            self._token_callback.total_input_tokens = 0
            self._token_callback.total_output_tokens = 0
            
            # Run agent in a thread to avoid blocking with callback
            result = await asyncio.to_thread(
                lambda: self.exec.invoke(
                    {"input": input_txt},
                    {"callbacks": [self._token_callback]}
                )
            )
            
            # Get token usage from callback
            total_input_tokens = self._token_callback.total_input_tokens
            total_output_tokens = self._token_callback.total_output_tokens
            
            print(f"[Token Usage] After callback - Input: {total_input_tokens}, Output: {total_output_tokens}, Callback was called: {self._token_callback.call_count} times")
            
            # Also try to extract from result as fallback if callback didn't capture it
            if total_input_tokens == 0 and total_output_tokens == 0:
                print(f"[Token Usage] Callback didn't capture tokens, trying fallback extraction...")
                # Check for token usage in intermediate steps
                # In LangChain, token usage is often in AIMessage objects within the steps
                if "intermediate_steps" in result:
                    for step in result["intermediate_steps"]:
                        # Step is a tuple: (AgentAction, observation)
                        # The observation might be an AIMessage with response_metadata
                        if len(step) > 1:
                            observation = step[1]
                        
                        # Check if observation is an AIMessage (from langchain_core.messages)
                        if hasattr(observation, "response_metadata"):
                            metadata = observation.response_metadata
                            if metadata and "token_usage" in metadata:
                                usage = metadata["token_usage"]
                                total_input_tokens += usage.get("prompt_tokens", 0) or usage.get("input_tokens", 0) or 0
                                total_output_tokens += usage.get("completion_tokens", 0) or usage.get("output_tokens", 0) or 0
                        
                        # Also check if it's a dict
                        elif isinstance(observation, dict):
                            if "response_metadata" in observation:
                                metadata = observation["response_metadata"]
                                if metadata and "token_usage" in metadata:
                                    usage = metadata["token_usage"]
                                    total_input_tokens += usage.get("prompt_tokens", 0) or usage.get("input_tokens", 0) or 0
                                    total_output_tokens += usage.get("completion_tokens", 0) or usage.get("output_tokens", 0) or 0
                            
                            # Sometimes token_usage is directly in the dict
                            if "token_usage" in observation:
                                usage = observation["token_usage"]
                                total_input_tokens += usage.get("prompt_tokens", 0) or usage.get("input_tokens", 0) or 0
                                total_output_tokens += usage.get("completion_tokens", 0) or usage.get("output_tokens", 0) or 0
                        
                        # Check if observation has messages attribute (list of messages)
                        if hasattr(observation, "messages"):
                            for msg in observation.messages:
                                if hasattr(msg, "response_metadata"):
                                    metadata = msg.response_metadata
                                    if metadata and "token_usage" in metadata:
                                        usage = metadata["token_usage"]
                                        total_input_tokens += usage.get("prompt_tokens", 0) or usage.get("input_tokens", 0) or 0
                                        total_output_tokens += usage.get("completion_tokens", 0) or usage.get("output_tokens", 0) or 0
                
                # Check if token usage is directly in result dict
                if isinstance(result, dict):
                    if "usage" in result:
                        usage = result["usage"]
                        total_input_tokens += usage.get("prompt_tokens", 0) or usage.get("input_tokens", 0) or 0
                        total_output_tokens += usage.get("completion_tokens", 0) or usage.get("output_tokens", 0) or 0
                    # Check for llm_output which sometimes contains usage
                    if "llm_output" in result and isinstance(result["llm_output"], dict):
                        if "token_usage" in result["llm_output"]:
                            usage = result["llm_output"]["token_usage"]
                            total_input_tokens += usage.get("prompt_tokens", 0) or usage.get("input_tokens", 0) or 0
                            total_output_tokens += usage.get("completion_tokens", 0) or usage.get("output_tokens", 0) or 0
            
            # Debug: Print result structure if tokens are still 0
            if total_input_tokens == 0 and total_output_tokens == 0:
                print(f"[Token Usage Debug] Result keys: {list(result.keys()) if isinstance(result, dict) else 'Not a dict'}")
                if "intermediate_steps" in result:
                    print(f"[Token Usage Debug] Intermediate steps count: {len(result['intermediate_steps'])}")
                    if result["intermediate_steps"]:
                        print(f"[Token Usage Debug] First step type: {type(result['intermediate_steps'][0])}")
                        if len(result["intermediate_steps"][0]) > 1:
                            obs = result["intermediate_steps"][0][1]
                            print(f"[Token Usage Debug] Observation type: {type(obs)}")
                            print(f"[Token Usage Debug] Observation attributes: {dir(obs) if hasattr(obs, '__dict__') else 'N/A'}")
            
            # Print token usage
            print(f"[Token Usage] Input tokens: {total_input_tokens}, Output tokens: {total_output_tokens}, Total: {total_input_tokens + total_output_tokens}")
            
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
                    fallback_place_ids = place_id_order[:5]
                    ranked = []
                    for pid in fallback_place_ids:
                        ranked.append({
                            "place_id": pid,
                            "justification": ["Could not rank; returning by order"]
                        })
            else:
                ranked = output
            
            # Ensure we have at most 5 items
            ranked = ranked[:5] if isinstance(ranked, list) else [ranked]
            
            # Map ranked restaurants back to full restaurant data from database
            # The LLM returns only place_id and justification, we fetch the full restaurant dict
            final_ranked = []
            for item in ranked:
                # LLM now returns place_id directly, not nested in restaurant dict
                ranked_place_id = item.get("place_id")
                
                # Handle legacy format (if LLM still returns restaurant dict)
                if not ranked_place_id:
                    ranked_restaurant = item.get("restaurant", {})
                    ranked_place_id = ranked_restaurant.get("place_id") or ranked_restaurant.get("google_place_id")
                
                # Get justification (should be a list)
                justification = item.get("justification", [])
                if isinstance(justification, str):
                    justification = [justification]
                elif not isinstance(justification, list):
                    justification = [str(justification)]
                
                # Find full restaurant by place_id from database
                full_restaurant = {}
                if ranked_place_id and ranked_place_id in place_id_to_restaurant:
                    full_restaurant = place_id_to_restaurant[ranked_place_id]
                
                # Serialize Firestore types (GeoPoint, Timestamp, etc.) to JSON-safe formats
                serialized_restaurant = self._serialize_restaurant(full_restaurant)
                
                final_ranked.append({
                    "restaurant": serialized_restaurant,
                    "justification": justification
                })
            
            return {
                "ranked_restaurants": final_ranked,
                "total_restaurants": len(cleaned_restaurants)
            }
            
        except Exception as e:
            # Log the full error for debugging
            error_msg = str(e)
            error_type = type(e).__name__
            print(f"[Rank Agent Error] {error_type}: {error_msg}")
            
            # Check if it's an authentication error
            if "401" in error_msg or "api_key" in error_msg.lower() or "authentication" in error_msg.lower():
                print("[Rank Agent Error] OpenAI API key issue detected. Please check OPENAI_API_KEY environment variable.")
                justification_msg = ["Ranking unavailable: API authentication error. Please check OpenAI API key configuration."]
            else:
                # Truncate long error messages but show more context
                justification_msg = [f"Ranking unavailable: {error_type} - {error_msg[:100]}"]
            
            # Fallback on any error: return top 5 by order
            fallback_place_ids = place_id_order[:5] if 'place_id_order' in locals() else place_ids[:5]
            fallback_restaurants = []
            for pid in fallback_place_ids:
                restaurant = place_id_to_restaurant.get(pid, {}) if 'place_id_to_restaurant' in locals() else {}
                # Serialize Firestore types before returning
                serialized_restaurant = self._serialize_restaurant(restaurant)
                fallback_restaurants.append({
                    "restaurant": serialized_restaurant,
                    "justification": justification_msg
                })
            return {
                "ranked_restaurants": fallback_restaurants,
                "total_restaurants": len(cleaned_restaurants) if 'cleaned_restaurants' in locals() else len(place_ids)
            }
