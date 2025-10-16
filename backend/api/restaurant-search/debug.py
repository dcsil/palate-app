import os
import json
from google.cloud import firestore

print("=== Firebase Debug ===")
print(f"Environment variable: {os.getenv('GOOGLE_APPLICATION_CREDENTIALS')}")
print(f"File exists: {os.path.exists(os.getenv('GOOGLE_APPLICATION_CREDENTIALS', ''))}")

# Check service account details
try:
    with open(os.getenv('GOOGLE_APPLICATION_CREDENTIALS', ''), 'r') as f:
        sa_data = json.load(f)
    print(f"Service account project: {sa_data.get('project_id')}")
    print(f"Service account email: {sa_data.get('client_email')}")
except Exception as e:
    print(f"Error reading service account: {e}")

# Test Firebase connection
try:
    db = firestore.Client()
    print("✅ Firebase client created successfully")
    
    # Test a simple query
    restaurants_ref = db.collection("restaurants")
    docs = list(restaurants_ref.limit(1).stream())
    print(f"✅ Query successful, found {len(docs)} documents")
    
except Exception as e:
    print(f"❌ Firebase error: {str(e)}")
    print(f"Error type: {type(e).__name__}")