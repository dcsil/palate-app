"""
FastAPI server for Toronto Restaurant Agent
"""

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Optional
import uvicorn
from agent import search_restaurants
from model import Restaurant, TokenUsage, ProcessingMetrics
from loguru import logger

# Initialize FastAPI app
app = FastAPI(
    title="Toronto Restaurant Agent API",
    description="AI-powered restaurant recommendation service using LangChain and Tavily search",
    version="1.0.0"
)

# Request model
class RestaurantRequest(BaseModel):
    query: str
    
    class Config:
        json_schema_extra = {
            "example": {
                "query": "Find the best Korean restaurant in Toronto, Canada. I want to eat with my family."
            }
        }

# Response model
class RestaurantResponse(BaseModel):
    restaurant: Optional[Restaurant] = None
    message: str
    metrics: ProcessingMetrics
    
    class Config:
        json_schema_extra = {
            "example": {
                "restaurant": {
                    "name": "Seoul Restaurant",
                    "address": "123 King Street, Toronto, ON",
                    "reason": "Highly rated Korean restaurant perfect for families"
                },
                "message": "Found a great Korean restaurant recommendation!",
                "metrics": {
                    "processing_time_seconds": 2.45,
                    "token_usage": {
                        "prompt_tokens": 1234,
                        "completion_tokens": 567,
                        "total_tokens": 1801,
                        "estimated_cost_usd": 0.004851
                    }
                }
            }
        }

@app.get("/")
async def root():
    """Health check endpoint"""
    return {"message": "Toronto Restaurant Agent API is running!", "status": "healthy"}

@app.get("/health")
async def health_check():
    """Detailed health check"""
    return {
        "status": "healthy",
        "service": "Toronto Restaurant Agent API",
        "version": "1.0.0"
    }

@app.post("/recommend", response_model=RestaurantResponse)
async def recommend_restaurant(request: RestaurantRequest):
    """
    Get a restaurant recommendation based on the query.
    
    - **query**: Your restaurant search query (e.g., "Find the best Korean restaurant in Toronto")
    
    Returns a recommended restaurant with name, address, and reasoning.
    """
    try:
        logger.info(f"Received restaurant request: {request.query}")
        
        # Search for restaurants using the agent
        result = search_restaurants(request.query)
        
        # Extract the restaurant recommendation
        restaurant = None
        message = "No restaurant found"
        
        if result.restaurants:
            restaurant = result.restaurants[0]
            message = f"Found a great restaurant recommendation: {restaurant.name}"
            logger.info(f"Recommended restaurant: {restaurant.name}")
        else:
            logger.warning("No restaurant found in the response")
        
        # Create response
        response = RestaurantResponse(
            restaurant=restaurant,
            message=message,
            metrics=result.metrics
        )
        
        logger.info(f"Request completed in {result.metrics.processing_time_seconds:.2f}s")
        return response
        
    except Exception as e:
        logger.error(f"Error processing request: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail=f"Error processing restaurant request: {str(e)}"
        )

if __name__ == "__main__":
    # Run the server
    uvicorn.run(
        "server:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
        log_level="info"
    )
