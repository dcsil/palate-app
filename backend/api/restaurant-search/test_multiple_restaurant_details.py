#!/usr/bin/env python3
"""
Test script for the new multiple_restaurant_details endpoint
"""
import pytest
pytest.importorskip("fastapi")
pytest.importorskip("firebase_admin")
import asyncio
import json
from main import app
from fastapi.testclient import TestClient


def test_multiple_restaurant_details():
    """Test the multiple restaurant details endpoint"""
    client = TestClient(app)
    
    # Test data - using some sample place IDs (you may need to replace with real ones)
    test_data = {
        "place_ids": [
            "ChIJN1t_tDeuEmsRUsoyG83frY4",  # Google Sydney
            "ChIJN1t_tDeuEmsRUsoyG83frY5",  # Another place ID
        ],
        "location": {
            "latitude": -33.8688,
            "longitude": 151.2093
        }
    }
    
    print("Testing multiple_restaurant_details endpoint...")
    print(f"Request data: {json.dumps(test_data, indent=2)}")
    
    try:
        response = client.post("/multiple_restaurant_details", json=test_data)
        
        print(f"Status Code: {response.status_code}")
        print(f"Response: {json.dumps(response.json(), indent=2)}")
        
        if response.status_code == 200:
            data = response.json()
            print(f"\n✅ Success! Found {data.get('total_found', 0)} restaurants")
            if data.get('errors'):
                print(f"⚠️  Errors: {len(data['errors'])} errors occurred")
                for error in data['errors']:
                    print(f"   - {error['place_id']}: {error['error']}")
        else:
            print(f"❌ Error: {response.status_code}")
            
    except Exception as e:
        print(f"❌ Exception: {str(e)}")

if __name__ == "__main__":
    test_multiple_restaurant_details()
