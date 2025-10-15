# FastAPI Boilerplate

Minimal FastAPI setup for the backend API.

## Quick Start

1. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

2. Run the server:
   ```bash
   uvicorn main:app --reload
   ```

3. Access the API:
   - API: http://localhost:8000
   - Docs: http://localhost:8000/docs
   - Health: http://localhost:8000/health

## Endpoints

- `GET /` - Hello World
- `GET /health` - Health check
- `GET /place/{place_id}` - Get detailed place information from Google Places API
- `POST /nearby-restaurants` - Get nearby restaurants and update them with place details in parallel

## New Nearby Restaurants Endpoint

The `/nearby-restaurants` endpoint finds the closest restaurants to a user's location and updates them with detailed information from Google Places API. See [NEARBY_ENDPOINT.md](NEARBY_ENDPOINT.md) for detailed documentation.

### Key Features:
- Finds 20 closest restaurants by distance
- Updates restaurants without search data in parallel
- Returns comprehensive place information
- Handles errors gracefully
