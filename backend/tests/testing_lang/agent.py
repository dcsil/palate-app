"""
Simplified LangChain Agent with Tavily Search for Restaurant Recommendations
"""

import os
import json
import time
import tiktoken
from typing import List
from langchain_openai import ChatOpenAI
from langchain_tavily import TavilySearch
from langgraph.prebuilt import create_react_agent
from langgraph.checkpoint.memory import MemorySaver
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import PydanticOutputParser
from model import AgentInput, AgentOutput, Restaurant, AgentMessage, TokenUsage, ProcessingMetrics
from dotenv import load_dotenv
from loguru import logger

# Configuration
load_dotenv()
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
TAVILY_API_KEY = os.getenv("TAVILY_API_KEY")

if not OPENAI_API_KEY:
    raise ValueError("OPENAI_API_KEY not found. Please set it in your .env file.")
if not TAVILY_API_KEY:
    raise ValueError("TAVILY_API_KEY not found. Please set it in your .env file.")

# Initialize the language model
model = ChatOpenAI(
    model="gpt-4.1-mini",
    temperature=0.7,
    api_key=OPENAI_API_KEY
)

# Initialize Tavily search tool
tavily_tool = TavilySearch(
    api_key=TAVILY_API_KEY,
    max_results=5,
    search_depth="basic"
)

# Create Pydantic parser for restaurant extraction
restaurant_parser = PydanticOutputParser(pydantic_object=Restaurant)

# Create the agent
memory = MemorySaver()
agent = create_react_agent(
    model=model,
    tools=[tavily_tool],
    checkpointer=memory
)

# Token counting setup
encoding = tiktoken.encoding_for_model("gpt-4.1-mini")

# Pricing for GPT-4o-mini (as of 2024)
PRICING = {
    "input": 0.0008 / 1000,  # $0.80 per 1K tokens
    "output": 0.0032 / 1000   # $3.20 per 1K tokens
}

def count_tokens(text: str) -> int:
    """Count tokens in text using tiktoken."""
    return len(encoding.encode(text))

def calculate_token_cost(prompt_tokens: int, completion_tokens: int) -> float:
    """Calculate estimated cost based on token usage."""
    input_cost = prompt_tokens * PRICING["input"]
    output_cost = completion_tokens * PRICING["output"]
    return input_cost + output_cost

def extract_restaurant_from_response(response: str) -> Restaurant:
    """Extract one restaurant using Pydantic parser."""
    try:
        # Use the model to generate structured output for a single restaurant
        structured_model = model.with_structured_output(Restaurant)
        
        # Create a prompt to extract the best restaurant from the response
        extraction_prompt = f"""
        From the following text about restaurants, extract the BEST restaurant recommendation.
        Return only the restaurant name and address in the required format.
        
        Text: {response}
        
        {restaurant_parser.get_format_instructions()}
        """
        
        # Get the structured output
        restaurant = structured_model.invoke(extraction_prompt)
        logger.info(f"Restaurant: {restaurant}")
        if restaurant and restaurant.name:
            return restaurant
        else:
            # Fallback if no restaurant found
            return Restaurant(name="No restaurant found", address="Address not specified")
            
    except Exception as e:
        print(f"Error in structured parsing: {e}")
        # Fallback to simple extraction
        return Restaurant(name="No restaurant found", address="Address not specified")


def search_restaurants(query: str) -> AgentOutput:
    """Search for restaurants using the agent."""
    # Start timing
    start_time = time.time()
    
    # Create input
    agent_input = AgentInput(message=query)
    
    # Count input tokens
    prompt_tokens = count_tokens(query)
    
    # Configuration for the conversation thread
    config = {"configurable": {"thread_id": "restaurant_search"}}
    
    # Process the query
    response_content = ""
    
    # Stream the agent's response
    for step in agent.stream(
        {"messages": [("user", query)]}, 
        config, 
        stream_mode="values"
    ):
        if step["messages"]:
            last_message = step["messages"][-1]
            if hasattr(last_message, 'content'):
                response_content += last_message.content
            else:
                response_content += str(last_message)
    
    logger.info(f"Response content: {response_content}")
    # Calculate processing time
    processing_time = time.time() - start_time
    
    # Count output tokens
    completion_tokens = count_tokens(response_content)
    total_tokens = prompt_tokens + completion_tokens
    
    # Calculate cost
    estimated_cost = calculate_token_cost(prompt_tokens, completion_tokens)
    
    # Extract one restaurant from response using Pydantic parser
    restaurant = extract_restaurant_from_response(response_content)
    restaurants = [restaurant] if restaurant.name != "No restaurant found" else []
    
    # Create token usage
    token_usage = TokenUsage(
        prompt_tokens=prompt_tokens,
        completion_tokens=completion_tokens,
        total_tokens=total_tokens,
        estimated_cost_usd=estimated_cost
    )
    
    # Create processing metrics
    metrics = ProcessingMetrics(
        processing_time_seconds=processing_time,
        token_usage=token_usage
    )
    
    # Create output
    agent_output = AgentOutput(
        restaurant=restaurant,
        restaurants=restaurants,
        metrics=metrics
    )
    
    return agent_output

