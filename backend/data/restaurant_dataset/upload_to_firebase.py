#!/usr/bin/env python3
"""
Script to upload restaurant data to Firebase Firestore database.
Reads from restaurant_data_filtered.csv and uploads to Firebase.
"""

import csv
import json
import os
import sys
from typing import Dict, List, Any
import time

try:
    import firebase_admin
    from firebase_admin import credentials, firestore
except ImportError:
    print("Firebase Admin SDK not installed. Installing...")
    os.system("pip install firebase-admin")
    import firebase_admin
    from firebase_admin import credentials, firestore

def initialize_firebase():
    """
    Initialize Firebase Admin SDK.
    You need to provide your Firebase service account key.
    """
    try:
        # Check if Firebase is already initialized
        firestore.client()
        print("Firebase already initialized.")
        return True
    except:
        pass
    
    # Look for service account key file
    service_account_paths = [
        "firebase-service-account.json",
        "service-account-key.json",
        "firebase-adminsdk.json",
        "../firebase-service-account.json",
        "../../firebase-service-account.json"
    ]
    
    service_account_file = None
    for path in service_account_paths:
        if os.path.exists(path):
            service_account_file = path
            break
    
    if not service_account_file:
        print("❌ Firebase service account key not found!")
        print("\nTo set up Firebase:")
        print("1. Go to Firebase Console: https://console.firebase.google.com/")
        print("2. Select your project")
        print("3. Go to Project Settings > Service Accounts")
        print("4. Click 'Generate new private key'")
        print("5. Save the JSON file as 'firebase-service-account.json' in this directory")
        print("\nAlternatively, set the GOOGLE_APPLICATION_CREDENTIALS environment variable")
        print("to point to your service account key file.")
        return False
    
    try:
        # Initialize Firebase with service account
        cred = credentials.Certificate(service_account_file)
        firebase_admin.initialize_app(cred)
        print(f"✅ Firebase initialized with service account: {service_account_file}")
        return True
    except Exception as e:
        print(f"❌ Error initializing Firebase: {str(e)}")
        return False

def read_restaurant_data(csv_file: str) -> List[Dict[str, Any]]:
    """
    Read restaurant data from CSV file and convert to list of dictionaries.
    """
    restaurants = []
    
    try:
        with open(csv_file, 'r', encoding='utf-8') as file:
            reader = csv.DictReader(file)
            
            for row_num, row in enumerate(reader, 1):
                # Convert price range to integer
                price_range = row.get('Price_Range_Int', '')
                if price_range.isdigit():
                    price_range = int(price_range)
                else:
                    price_range = None
                
                # Convert coordinates to float
                lat = row.get('google_lat', '')
                lng = row.get('google_lng', '')
                
                try:
                    lat = float(lat) if lat else None
                except ValueError:
                    lat = None
                    
                try:
                    lng = float(lng) if lng else None
                except ValueError:
                    lng = None
                
                # Parse google_types (comma-separated string)
                google_types = row.get('google_types', '')
                if google_types:
                    google_types = [t.strip() for t in google_types.split(',')]
                else:
                    google_types = []
                
                restaurant = {
                    'category': row.get('Category', ''),
                    'name': row.get('Restaurant Name', ''),
                    'price_range': price_range,
                    'google_place_id': row.get('google_place_id', ''),
                    'formatted_address': row.get('google_formatted_address', ''),
                    'latitude': lat,
                    'longitude': lng,
                    'google_types': google_types,
                    'created_at': firestore.SERVER_TIMESTAMP
                }
                
                restaurants.append(restaurant)
                
                if row_num % 1000 == 0:
                    print(f"Processed {row_num} restaurants...")
    
    except FileNotFoundError:
        print(f"❌ Error: File '{csv_file}' not found!")
        return []
    except Exception as e:
        print(f"❌ Error reading CSV file: {str(e)}")
        return []
    
    return restaurants

def upload_to_firestore(restaurants: List[Dict[str, Any]], collection_name: str = "restaurants", batch_size: int = 500):
    """
    Upload restaurants to Firestore in batches.
    """
    if not restaurants:
        print("❌ No restaurant data to upload!")
        return False
    
    try:
        db = firestore.client()
        
        print(f"📤 Uploading {len(restaurants)} restaurants to Firestore...")
        print(f"Collection: {collection_name}")
        print(f"Batch size: {batch_size}")
        
        # Upload in batches
        total_uploaded = 0
        total_batches = (len(restaurants) + batch_size - 1) // batch_size
        
        for batch_num in range(total_batches):
            start_idx = batch_num * batch_size
            end_idx = min(start_idx + batch_size, len(restaurants))
            batch_restaurants = restaurants[start_idx:end_idx]
            
            print(f"📦 Processing batch {batch_num + 1}/{total_batches} ({len(batch_restaurants)} restaurants)...")
            
            # Create a batch for this group
            batch = db.batch()
            
            for restaurant in batch_restaurants:
                # Create a new document reference
                doc_ref = db.collection(collection_name).document()
                batch.set(doc_ref, restaurant)
            
            # Commit the batch
            batch.commit()
            
            total_uploaded += len(batch_restaurants)
            print(f"✅ Uploaded batch {batch_num + 1}/{total_batches} ({total_uploaded}/{len(restaurants)} total)")
            
            # Small delay to avoid rate limiting
            if batch_num < total_batches - 1:
                time.sleep(0.1)
        
        print(f"🎉 Successfully uploaded {total_uploaded} restaurants to Firestore!")
        return True
        
    except Exception as e:
        print(f"❌ Error uploading to Firestore: {str(e)}")
        return False

def verify_upload(collection_name: str = "restaurants", sample_size: int = 5):
    """
    Verify the upload by checking a few documents.
    """
    try:
        db = firestore.client()
        
        print(f"\n🔍 Verifying upload in collection '{collection_name}'...")
        
        # Get a sample of documents
        docs = db.collection(collection_name).limit(sample_size).stream()
        
        count = 0
        for doc in docs:
            count += 1
            data = doc.to_dict()
            print(f"Sample {count}: {data.get('name', 'Unknown')} - {data.get('category', 'Unknown')} - Price: {data.get('price_range', 'N/A')}")
        
        # Get total count
        total_docs = db.collection(collection_name).count().get()
        print(f"\n📊 Total documents in collection: {total_docs[0][0].value}")
        
        return True
        
    except Exception as e:
        print(f"❌ Error verifying upload: {str(e)}")
        return False

def main():
    """
    Main function to orchestrate the upload process.
    """
    print("🍽️  Restaurant Data Firebase Uploader")
    print("=" * 50)
    
    # Configuration
    csv_file = "restaurant_data_filtered.csv"
    collection_name = "restaurants"
    batch_size = 500
    
    # Check if CSV file exists
    if not os.path.exists(csv_file):
        print(f"❌ Error: CSV file '{csv_file}' not found!")
        print("Please run the extract_columns.py script first to generate the filtered data.")
        return
    
    # Initialize Firebase
    if not initialize_firebase():
        return
    
    # Read restaurant data
    print(f"\n📖 Reading restaurant data from {csv_file}...")
    restaurants = read_restaurant_data(csv_file)
    
    if not restaurants:
        print("❌ No restaurant data found!")
        return
    
    print(f"✅ Loaded {len(restaurants)} restaurants")
    
    # Show sample data
    print(f"\n📋 Sample restaurant data:")
    for i, restaurant in enumerate(restaurants[:3]):
        print(f"  {i+1}. {restaurant['name']} - {restaurant['category']} - Price: {restaurant['price_range']}")
    
    # Confirm upload
    print(f"\n⚠️  About to upload {len(restaurants)} restaurants to Firebase Firestore")
    print(f"Collection: {collection_name}")
    response = input("Continue? (y/N): ").strip().lower()
    
    if response != 'y':
        print("❌ Upload cancelled.")
        return
    
    # Upload to Firestore
    print(f"\n🚀 Starting upload...")
    success = upload_to_firestore(restaurants, collection_name, batch_size)
    
    if success:
        # Verify upload
        verify_upload(collection_name)
        print(f"\n🎉 Upload completed successfully!")
    else:
        print(f"\n❌ Upload failed!")

if __name__ == "__main__":
    main()
