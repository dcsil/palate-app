import os
from dotenv import load_dotenv
from google.cloud import firestore

load_dotenv()
GCP_PROJECT = os.environ.get("GCP_PROJECT")
print(f"GCP_PROJECT: {GCP_PROJECT}")

# Try to connect
try:
    client = firestore.Client(project=GCP_PROJECT)
    print("✅ Connected to Firestore!")
    
    # List all collections
    print("\n📚 Available collections:")
    collections = client.collections()
    collection_list = list(collections)
    if collection_list:
        for coll in collection_list:
            print(f"  - {coll.id}")
    else:
        print("  ⚠️ No collections found!")
    
    # Try to fetch documents from "restaurants" collection
    print("\n🔍 Checking 'restaurants' collection:")
    docs = client.collection("restaurants").limit(5).stream()
    doc_list = list(docs)
    print(f"✅ Found {len(doc_list)} documents")
    
    if doc_list:
        d = doc_list[0].to_dict()
        print(f"\n📄 Sample document (first 5 fields):")
        for i, (key, value) in enumerate(d.items()):
            if i >= 5:
                print("  ...")
                break
            print(f"  {key}: {value}")
        
        print(f"\n📄 All keys in this document:")
        print(f"  {list(d.keys())}")
    else:
        print("  ⚠️ No documents found in 'restaurants' collection!")
            
except Exception as e:
    print(f"❌ Error: {type(e).__name__}: {e}")
    import traceback
    traceback.print_exc()