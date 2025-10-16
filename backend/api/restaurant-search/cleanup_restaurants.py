#!/usr/bin/env python3
"""
Temporary script to clean up restaurant documents in Firebase.
This script will query all restaurants and remove documents that contain specific strings.
"""

import os
import sys
from datetime import datetime
from google.cloud import firestore
from google.oauth2 import service_account
import json

def initialize_firebase():
    """Initialize Firebase connection"""
    try:
        # Try to use Application Default Credentials first
        db = firestore.Client()
        print("✅ Connected to Firebase using Application Default Credentials")
        return db
    except Exception as adc_err:
        print(f"❌ ADC failed: {str(adc_err)}")
        
        # Try service account JSON
        try:
            service_account_path = os.getenv('GOOGLE_APPLICATION_CREDENTIALS')
            if service_account_path and os.path.exists(service_account_path):
                credentials = service_account.Credentials.from_service_account_file(service_account_path)
                db = firestore.Client(credentials=credentials)
                print(f"✅ Connected to Firebase using service account: {service_account_path}")
                return db
            else:
                print("❌ No service account file found")
                return None
        except Exception as sa_err:
            print(f"❌ Service account failed: {str(sa_err)}")
            return None

def query_all_restaurants(db):
    """Query all restaurants from Firebase"""
    try:
        restaurants_ref = db.collection("restaurants")
        docs = restaurants_ref.stream()
        
        restaurants = []
        for doc in docs:
            data = doc.to_dict()
            restaurants.append({
                'doc_id': doc.id,
                'data': data
            })
        
        print(f"📊 Found {len(restaurants)} restaurants in database")
        return restaurants
    except Exception as e:
        print(f"❌ Error querying restaurants: {str(e)}")
        return []

def find_documents_with_dine_in_false(restaurants):
    """Find documents where dine_in is explicitly set to false"""
    matching_docs = []
    
    for restaurant in restaurants:
        doc_id = restaurant['doc_id']
        data = restaurant['data']
        
        # Check if dine_in is explicitly false
        # Look in service_options.dine_in or directly in dine_in field
        service_options = data.get('service_options', {})
        dine_in = service_options.get('dine_in') if service_options else data.get('dine_in')
        
        # Only delete if dine_in is explicitly False (not None, not missing)
        if dine_in is False:
            matching_docs.append({
                'doc_id': doc_id,
                'name': data.get('name', 'Unknown'),
                'place_id': data.get('google_place_id', 'Unknown'),
                'dine_in_value': dine_in,
                'reason': 'dine_in is explicitly false'
            })
    
    return matching_docs

def find_documents_with_strings(restaurants, search_strings):
    """Find documents that contain any of the search strings"""
    matching_docs = []
    
    for restaurant in restaurants:
        doc_id = restaurant['doc_id']
        data = restaurant['data']
        
        # Convert data to string for searching
        data_str = json.dumps(data, default=str).lower()
        
        # Check if any search string is found
        found_strings = []
        for search_string in search_strings:
            if search_string.lower() in data_str:
                found_strings.append(search_string)
        
        if found_strings:
            matching_docs.append({
                'doc_id': doc_id,
                'name': data.get('name', 'Unknown'),
                'place_id': data.get('google_place_id', 'Unknown'),
                'found_strings': found_strings
            })
    
    return matching_docs

def delete_documents(db, doc_ids):
    """Delete documents by their IDs"""
    deleted_count = 0
    
    for doc_id in doc_ids:
        try:
            doc_ref = db.collection("restaurants").document(doc_id)
            doc_ref.delete()
            deleted_count += 1
            print(f"🗑️  Deleted document: {doc_id}")
        except Exception as e:
            print(f"❌ Error deleting document {doc_id}: {str(e)}")
    
    return deleted_count

def find_restaurant_by_place_id(db, place_id):
    """Find a restaurant by its place_id (google_place_id)"""
    try:
        restaurants_ref = db.collection("restaurants")
        query = restaurants_ref.where("google_place_id", "==", place_id).limit(1)
        docs = list(query.stream())
        
        if docs:
            doc = docs[0]
            data = doc.to_dict()
            return {
                'doc_id': doc.id,
                'name': data.get('name', 'Unknown'),
                'place_id': data.get('google_place_id', 'Unknown'),
                'data': data
            }
        return None
    except Exception as e:
        print(f"❌ Error searching for restaurant: {str(e)}")
        return None

def main():
    print("🧹 Restaurant Cleanup Script")
    print("=" * 50)
    
    # Initialize Firebase
    db = initialize_firebase()
    if not db:
        print("❌ Failed to connect to Firebase")
        return
    
    print("Choose an option:")
    print("1. Search and delete by place_id")
    print("2. Delete restaurants with dine_in = false")
    print("3. Search and delete by string content")
    
    choice = input("\nEnter your choice (1, 2, or 3): ").strip()
    
    if choice == "1":
        # Search by place_id
        place_id = input("Enter the place_id to search for: ").strip()
        if not place_id:
            print("❌ No place_id provided")
            return
        
        print(f"🔍 Searching for restaurant with place_id: {place_id}")
        restaurant = find_restaurant_by_place_id(db, place_id)
        
        if not restaurant:
            print(f"❌ No restaurant found with place_id: {place_id}")
            return
        
        print(f"\n📋 Found restaurant:")
        print("-" * 80)
        print(f"📄 Doc ID: {restaurant['doc_id']}")
        print(f"   Name: {restaurant['name']}")
        print(f"   Place ID: {restaurant['place_id']}")
        print()
        
        # Ask for confirmation
        print("⚠️  WARNING: This will permanently delete the above restaurant!")
        confirm = input("Type 'DELETE' to confirm deletion: ")
        
        if confirm == "DELETE":
            deleted_count = delete_documents(db, [restaurant['doc_id']])
            print(f"\n✅ Successfully deleted {deleted_count} restaurant")
        else:
            print("❌ Deletion cancelled")
    
    elif choice == "2":
        # Delete restaurants with dine_in = false
        restaurants = query_all_restaurants(db)
        if not restaurants:
            print("❌ No restaurants found or error occurred")
            return
        
        print("🔍 Searching for documents where dine_in is explicitly false...")
        matching_docs = find_documents_with_dine_in_false(restaurants)
        
        if not matching_docs:
            print("✅ No documents found with dine_in = false")
            return
        
        print(f"\n📋 Found {len(matching_docs)} documents with dine_in = false:")
        print("-" * 80)
        for doc in matching_docs:
            print(f"📄 Doc ID: {doc['doc_id']}")
            print(f"   Name: {doc['name']}")
            print(f"   Place ID: {doc['place_id']}")
            print(f"   Reason: {doc['reason']}")
            print(f"   dine_in value: {doc['dine_in_value']}")
            print()
        
        # Ask for confirmation before deletion
        print("⚠️  WARNING: This will permanently delete the above documents!")
        print("These are restaurants where dine_in is explicitly set to false.")
        confirm = input("Type 'DELETE' to confirm deletion: ")
        
        if confirm == "DELETE":
            doc_ids = [doc['doc_id'] for doc in matching_docs]
            deleted_count = delete_documents(db, doc_ids)
            print(f"\n✅ Successfully deleted {deleted_count} documents")
        else:
            print("❌ Deletion cancelled")
    
    elif choice == "3":
        # Search by string content
        search_strings = input("Enter search strings (comma-separated): ").strip()
        if not search_strings:
            print("❌ No search strings provided")
            return
        
        search_list = [s.strip() for s in search_strings.split(",") if s.strip()]
        
        restaurants = query_all_restaurants(db)
        if not restaurants:
            print("❌ No restaurants found or error occurred")
            return
        
        print(f"🔍 Searching for documents containing: {search_list}")
        matching_docs = find_documents_with_strings(restaurants, search_list)
        
        if not matching_docs:
            print("✅ No documents found containing the search strings")
            return
        
        print(f"\n📋 Found {len(matching_docs)} documents containing search strings:")
        print("-" * 80)
        for doc in matching_docs:
            print(f"📄 Doc ID: {doc['doc_id']}")
            print(f"   Name: {doc['name']}")
            print(f"   Place ID: {doc['place_id']}")
            print(f"   Contains: {', '.join(doc['found_strings'])}")
            print()
        
        # Ask for confirmation before deletion
        print("⚠️  WARNING: This will permanently delete the above documents!")
        confirm = input("Type 'DELETE' to confirm deletion: ")
        
        if confirm == "DELETE":
            doc_ids = [doc['doc_id'] for doc in matching_docs]
            deleted_count = delete_documents(db, doc_ids)
            print(f"\n✅ Successfully deleted {deleted_count} documents")
        else:
            print("❌ Deletion cancelled")
    
    else:
        print("❌ Invalid choice. Please run the script again and choose 1, 2, or 3.")

if __name__ == "__main__":
    main()
