import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Google Places API configuration
GOOGLE_PLACES_API_KEY = os.getenv('GOOGLE_PLACES_API_KEY')

if not GOOGLE_PLACES_API_KEY:
    raise ValueError("GOOGLE_PLACES_API_KEY environment variable is required")
