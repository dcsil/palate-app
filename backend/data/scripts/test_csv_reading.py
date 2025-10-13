#!/usr/bin/env python3
"""
Test script to verify CSV reading functionality without Firebase.
"""

import csv
import os

def test_csv_reading():
    """
    Test reading the CSV file and show sample data.
    """
    csv_file = "../data/processed/restaurant_data_filtered.csv"
    
    if not os.path.exists(csv_file):
        print(f"❌ Error: CSV file '{csv_file}' not found!")
        return
    
    print(f"📖 Testing CSV reading from {csv_file}...")
    
    try:
        with open(csv_file, 'r', encoding='utf-8') as file:
            reader = csv.DictReader(file)
            
            # Count total rows
            rows = list(reader)
            total_rows = len(rows)
            
            print(f"✅ Successfully read {total_rows} restaurants")
            print(f"📋 Columns: {', '.join(reader.fieldnames)}")
            
            # Show sample data
            print(f"\n📋 Sample data (first 3 restaurants):")
            for i, row in enumerate(rows[:3]):
                print(f"\nRestaurant {i+1}:")
                print(f"  Name: {row.get('Restaurant Name', 'N/A')}")
                print(f"  Category: {row.get('Category', 'N/A')}")
                print(f"  Price Range: {row.get('Price_Range_Int', 'N/A')}")
                print(f"  Address: {row.get('google_formatted_address', 'N/A')}")
                print(f"  Google Place ID: {row.get('google_place_id', 'N/A')}")
                print(f"  Coordinates: {row.get('google_lat', 'N/A')}, {row.get('google_lng', 'N/A')}")
                print(f"  Types: {row.get('google_types', 'N/A')}")
            
            # Show price range distribution
            print(f"\n📊 Price Range Distribution:")
            price_counts = {}
            for row in rows:
                price = row.get('Price_Range_Int', '')
                price_counts[price] = price_counts.get(price, 0) + 1
            
            for price, count in sorted(price_counts.items()):
                price_label = {
                    '1': 'Under $10',
                    '2': '$11-30',
                    '3': '$31-60',
                    '4': 'Above $61'
                }.get(price, f'Unknown ({price})')
                print(f"  {price} ({price_label}): {count} restaurants")
            
            # Show category distribution
            print(f"\n📊 Category Distribution (top 10):")
            category_counts = {}
            for row in rows:
                category = row.get('Category', 'Unknown')
                category_counts[category] = category_counts.get(category, 0) + 1
            
            sorted_categories = sorted(category_counts.items(), key=lambda x: x[1], reverse=True)
            for category, count in sorted_categories[:10]:
                print(f"  {category}: {count} restaurants")
            
            print(f"\n✅ CSV reading test completed successfully!")
            print(f"📈 Ready to upload {total_rows} restaurants to Firebase!")
            
    except Exception as e:
        print(f"❌ Error reading CSV file: {str(e)}")

if __name__ == "__main__":
    test_csv_reading()
