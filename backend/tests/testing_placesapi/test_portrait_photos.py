#!/usr/bin/env python3
"""
Script for testing Google Places API with portrait (vertical) photo filtering
Perfect for TikTok-like platforms that need vertical images
"""

import googlemaps
from config import GOOGLE_PLACES_API_KEY
from photo_downloader import download_place_photos

def test_portrait_photos(place_id=None):
    """Test Google Places API with portrait photo filtering for TikTok-like platforms"""
    
    # Initialize the Google Maps client
    gmaps = googlemaps.Client(key=GOOGLE_PLACES_API_KEY)
    
    try:
        if place_id:
            # Use provided place ID directly
            details = gmaps.place(place_id=place_id)
        else:
            # Fallback to search query
            query = "Terroni - Adelaide in Toronto"
            places_result = gmaps.places(query=query)
            
            if places_result['status'] == 'OK' and places_result['results']:
                place_id = places_result['results'][0]['place_id']
                details = gmaps.place(place_id=place_id)
            else:
                return
        
        if details['status'] == 'OK':
            place_details = details['result']
            
            # Check for photos
            if 'photos' in place_details:
                # Download photos with portrait filtering
                download_place_photos(
                    place_details, 
                    max_photos=10,  # Limit to 5 photos per place
                    min_width=400,   # Minimum quality
                    min_height=600,  # Minimum height for portrait
                    portrait_only=False,  # Only portrait images
                    min_aspect_ratio=0.5,  # 0.5 = 1:2 ratio (very tall)
                    max_aspect_ratio=0.8   # 0.8 = 4:5 ratio (slightly tall)
                )
        
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    import sys
    
    if len(sys.argv) > 1:
        # Use place ID from command line argument
        place_id = sys.argv[1]
        test_portrait_photos(place_id)
    else:
        # Use default search query
        test_portrait_photos()
