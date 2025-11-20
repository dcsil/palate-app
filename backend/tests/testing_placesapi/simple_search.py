#!/usr/bin/env python3
"""
Simple Google Places API search script
"""

import googlemaps
from config import GOOGLE_PLACES_API_KEY

def search_restaurant(query):
    """Search for a restaurant using Google Places API"""
    
    # Initialize the Google Maps client
    gmaps = googlemaps.Client(key=GOOGLE_PLACES_API_KEY)
    
    try:
        # Text search
        places_result = gmaps.places(query=query)
        
        if places_result['status'] == 'OK' and places_result['results']:
            place = places_result['results'][0]
            return {
                'name': place['name'],
                'place_id': place['place_id'],
                'rating': place.get('rating'),
                'address': place.get('formatted_address'),
                'photos': len(place.get('photos', []))
            }
        else:
            return None
            
    except Exception as e:
        return None

if __name__ == "__main__":
    # Search for a restaurant
    result = search_restaurant("best japanese restaurant toronto")
    if result:
        print(f"Found: {result['name']}")
        print(f"Place ID: {result['place_id']}")
        print(f"Address: {result['address']}")
        print(f"Rating: {result['rating']}")
        print(f"Photos: {result['photos']}")
    else:
        print("Restaurant not found")
