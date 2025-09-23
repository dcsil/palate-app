"""
Simplified Pydantic models for LLM agent input and output tracking
"""

from typing import List, Optional
from pydantic import BaseModel, Field
from datetime import datetime

class AgentMessage(BaseModel):
    """Simple message model for agent communication"""
    message: str = Field(..., description="The message content")
    timestamp: datetime = Field(default_factory=datetime.now, description="When the message was created")

class Restaurant(BaseModel):
    """Simple restaurant model"""
    name: str = Field(..., description="Name of the restaurant")
    address: str = Field(..., description="Address of the restaurant")
    reason: str = Field(..., description="Detailed reason for the restaurant recommendation above other options")

class AgentInput(BaseModel):
    """Input to the LLM agent"""
    message: str = Field(..., description="Input message to the agent")

class TokenUsage(BaseModel):
    """Token usage tracking"""
    prompt_tokens: int = Field(default=0, description="Number of prompt tokens used")
    completion_tokens: int = Field(default=0, description="Number of completion tokens generated")
    total_tokens: int = Field(default=0, description="Total tokens used")
    estimated_cost_usd: float = Field(default=0.0, description="Estimated cost in USD")

class ProcessingMetrics(BaseModel):
    """Processing time and performance metrics"""
    processing_time_seconds: float = Field(..., description="Total processing time in seconds")
    token_usage: TokenUsage = Field(..., description="Token usage information")
    timestamp: datetime = Field(default_factory=datetime.now, description="When the processing completed")

class AgentOutput(BaseModel):
    """Output from the LLM agent"""
    restaurant: Restaurant = Field(..., description="Agent's response message")
    restaurants: List[Restaurant] = Field(default_factory=list, description="Restaurants found")
    metrics: ProcessingMetrics = Field(..., description="Processing metrics and token usage")