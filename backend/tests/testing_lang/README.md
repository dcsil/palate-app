# Toronto Restaurant Agent API

A FastAPI server that provides AI-powered restaurant recommendations using LangChain, Tavily search, and Pydantic models for structured data.

## Features

- 🚀 FastAPI REST API for restaurant recommendations
- 🔍 Searches for restaurant recommendations using Tavily search
- 🧠 Powered by OpenAI's GPT-4.1-mini model
- 📊 Pydantic models for structured input/output tracking
- 🍽️ Returns restaurant name, address, and reasoning
- ⏱️ Processing time and token cost tracking
- 📖 Interactive API documentation (Swagger UI)
- 🧠 Memory-enabled conversations

## Setup

1. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Get API Keys:**
   - Get your OpenAI API key from [OpenAI Platform](https://platform.openai.com/api-keys)
   - Get your Tavily API key from [Tavily](https://tavily.com/)

3. **Create environment file:**
   Edit `.env` and add your actual API keys:
   ```
   OPENAI_API_KEY=your_actual_openai_key
   TAVILY_API_KEY=your_actual_tavily_key
   ```

## Usage

### Start the FastAPI Server
```bash
python main.py
# or
python server.py
```

This starts a FastAPI server with the following endpoints:
- `GET /` - Health check
- `GET /health` - Detailed health check  
- `POST /recommend` - Get restaurant recommendation
- `GET /docs` - Interactive API documentation

### API Usage

#### Get Restaurant Recommendation
```bash
curl -X POST "http://localhost:8000/recommend" \
     -H "Content-Type: application/json" \
     -d '{"query": "Find the best Korean restaurant in Toronto for families"}'
```

#### Response Format
```json
{
  "restaurant": {
    "name": "Seoul Restaurant",
    "address": "123 King Street, Toronto, ON",
    "reason": "Highly rated Korean restaurant perfect for families"
  },
  "message": "Found a great restaurant recommendation: Seoul Restaurant",
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
```

## Pydantic Models

The agent uses simple Pydantic models for tracking:

- **AgentMessage**: Contains the message content and timestamp
- **Restaurant**: Contains restaurant name and address
- **AgentInput**: Input message to the agent
- **AgentOutput**: Agent response with message and list of restaurants

## Based on LangChain Tutorial

This implementation is based on the [LangChain Agents Tutorial](https://python.langchain.com/docs/tutorials/agents/) and uses:
- LangGraph for agent creation
- Tavily for web search
- OpenAI for language model
- Pydantic for structured data validation
