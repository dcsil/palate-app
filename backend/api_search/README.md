# Vera Backend API - Restaurant Search

A FastAPI-based backend service for searching restaurants using Google Places API and Firestore database with fuzzy matching capabilities.

## Project Structure

```
api_search/
├── main.py                    # FastAPI application entry point
├── deps.py                    # Dependency injection
├── requirements.txt           # Python dependencies
├── firebase-service.json      # Firebase service account credentials
├── agents/                    # AI agent modules
│   ├── __init__.py
│   ├── single_source.py       # Main search logic
│   ├── places_pruner.py       # LangChain agent for place filtering
│   ├── tools_db.py           # Database tools for agents
│   └── tools_google.py       # Google Places tools for agents
├── models/                    # Pydantic models
│   ├── __init__.py
│   ├── requests.py           # Request models
│   └── responses.py          # Response models
├── routers/                   # FastAPI routers
│   ├── __init__.py
│   ├── health.py             # Health check endpoint
│   └── agent_places.py       # Search endpoints
└── services/                  # External service integrations
    ├── __init__.py
    ├── firestore.py          # Firestore database client
    └── google_places.py      # Google Places API client
```

## Features

- **Dual Search Sources**: Search via Google Places API or Firestore database
- **Fuzzy Matching**: Intelligent text matching using rapidfuzz
- **Location-based Search**: Search by coordinates with radius
- **CORS Support**: Cross-origin request handling
- **Demo Mode**: Hardcoded data for testing without API calls
- **LangChain Integration**: AI-powered place filtering and pruning

## Setup Instructions

### 1. Prerequisites

- Python 3.8+
- Google Cloud Project with Firestore enabled
- Google Places API key
- Firebase service account credentials

### 2. Install Dependencies

```bash
pip install -r requirements.txt
```

### 3. Environment Configuration

Create a `.env` file in the project root:

```env
# Google Cloud Platform
GCP_PROJECT=your-gcp-project-id
GOOGLE_APPLICATION_CREDENTIALS=./firebase-service.json

# Google Places API
GOOGLE_PLACES_API_KEY=your-google-places-api-key

# Demo Mode (optional)
DEMO_MODE=false
```

### 4. Firebase Setup

1. Download your Firebase service account JSON file
2. Rename it to `firebase-service.json`
3. Place it in the project root directory
4. Ensure the service account has Firestore read/write permissions

### 5. Google Places API Setup

1. Enable the Places API in your Google Cloud Console
2. Create an API key with Places API access
3. Add the API key to your `.env` file

### 6. Firestore Database

Ensure your Firestore database has a `restaurants` collection with documents containing:
- `name` (string): Restaurant name
- `address` (string): Restaurant address
- `google_place_id` (string): Google Places ID
- Additional fields as needed

## Running the Application

### Development Mode

```bash
uvicorn main:app --reload
```

### Production Mode

```bash
uvicorn main:app --host 0.0.0.0 --port 8000
```

The API will be available at:
- **Local**: http://127.0.0.1:8000
- **API Documentation**: http://127.0.0.1:8000/docs
- **Alternative Docs**: http://127.0.0.1:8000/redoc

## API Endpoints

### Health Check
```
GET /health
```
Returns server status.

### Search Restaurants
```
POST /agent/search
```

**Request Body:**
```json
{
  "query": "sushi restaurant",
  "address": "123 Main St, Toronto",
  "google_place_id": "ChIJ...",
  "lat": 43.6532,
  "lng": -79.3832,
  "radius_m": 1000,
  "source": "places"
}
```

**Response:**
```json
{
  "source": "places",
  "total": 3,
  "items": [
    {
      "name": "Sushi Kaji",
      "address": "860 The Queensway, Etobicoke, ON",
      "google_place_id": "ChIJe-RPj680K4gRnEWwf2pBYao",
      "score": 85.5
    }
  ]
}
```

## Search Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `query` | string | Free-text search term |
| `address` | string | Address to search near |
| `google_place_id` | string | Specific Google Place ID |
| `lat` | float | Latitude for location search |
| `lng` | float | Longitude for location search |
| `radius_m` | int | Search radius in meters (default: 1000) |
| `source` | string | "places" or "db" |

## Search Sources

### Google Places API (`source: "places"`)
- Real-time restaurant data from Google
- Location-based search with radius
- Returns current business information

### Database Search (`source: "db"`)
- Searches your Firestore database
- Uses fuzzy string matching
- Includes relevance scores
- Faster for large datasets

## Demo Mode

Set `DEMO_MODE=true` in your `.env` file to use hardcoded demo data instead of making actual API calls. Useful for testing and development.

## CORS Configuration

The API is configured with CORS middleware to allow requests from:
- `http://localhost:*` (development)
- `https://preview.flutterflow.app` (FlutterFlow preview)
- `https://palate-cve8jj.flutterflow.app` (production)
- `https://palate.it.com` (custom domain)

## Dependencies

- **FastAPI**: Web framework
- **uvicorn**: ASGI server
- **pydantic**: Data validation
- **langchain**: AI agent framework
- **rapidfuzz**: Fuzzy string matching
- **google-cloud-firestore**: Firestore client
- **httpx**: HTTP client for Google Places API
- **python-dotenv**: Environment variable management

## Development

### Adding New Search Sources

1. Create a new method in `agents/single_source.py`
2. Add the source to the main search logic
3. Update the request model if needed

### Adding New Agent Tools

1. Create tool functions in `agents/tools_*.py`
2. Import and register in `agents/places_pruner.py`
3. Update the agent prompt if needed

## Deployment

### Cloud Run

1. Build and push Docker image
2. Deploy to Google Cloud Run
3. Set environment variables
4. Configure service account permissions

### Environment Variables for Production

```env
GCP_PROJECT=your-production-project
GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account.json
GOOGLE_PLACES_API_KEY=your-production-api-key
DEMO_MODE=false
```

## Troubleshooting

### Common Issues

1. **Import errors**: Ensure all dependencies are installed
2. **Firestore connection**: Check service account credentials and permissions
3. **Google Places API**: Verify API key and enable Places API
4. **CORS errors**: Update allowed origins in `main.py`

### Debug Mode

Enable debug logging by adding print statements in the search functions to trace data flow.

## License

This project is part of the Vera application suite.
