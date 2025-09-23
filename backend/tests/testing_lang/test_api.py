"""
Test script for the FastAPI restaurant agent
"""

import requests
import json

def test_api():
    """Test the restaurant recommendation API"""
    base_url = "http://localhost:8000"
    
    # Test health check
    print("🔍 Testing health check...")
    try:
        response = requests.get(f"{base_url}/health")
        print(f"Health check: {response.status_code} - {response.json()}")
    except Exception as e:
        print(f"Health check failed: {e}")
        return
    
    # Test restaurant recommendation
    print("\n🍽️  Testing restaurant recommendation...")
    test_query = {
        "query": "Find the best Korean restaurant in Toronto for families"
    }
    
    try:
        response = requests.post(
            f"{base_url}/recommend",
            json=test_query,
            headers={"Content-Type": "application/json"}
        )
        
        if response.status_code == 200:
            result = response.json()
            print(f"✅ Success! Status: {response.status_code}")
            print(f"Restaurant: {result.get('restaurant', {}).get('name', 'N/A')}")
            print(f"Address: {result.get('restaurant', {}).get('address', 'N/A')}")
            print(f"Message: {result.get('message', 'N/A')}")
            print(f"Processing time: {result.get('metrics', {}).get('processing_time_seconds', 0):.2f}s")
            print(f"Cost: ${result.get('metrics', {}).get('token_usage', {}).get('estimated_cost_usd', 0):.6f}")
        else:
            print(f"❌ Error: {response.status_code} - {response.text}")
            
    except Exception as e:
        print(f"❌ Request failed: {e}")

if __name__ == "__main__":
    print("🧪 Testing Toronto Restaurant Agent API")
    print("=" * 50)
    print("Make sure the server is running: python server.py")
    print()
    test_api()
