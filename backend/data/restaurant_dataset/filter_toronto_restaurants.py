#!/usr/bin/env python3
"""
Divide restaurant CSV by address cities
"""

import pandas as pd
import re
import os

def categorize_restaurants_by_city(input_file="trt_rest.csv"):
    """
    Categorize restaurants by the cities mentioned in their addresses
    
    Args:
        input_file (str): Input CSV file name
    """
    
    print(f"Loading data from {input_file}...")
    
    # Read the CSV file
    df = pd.read_csv(input_file)
    
    print(f"Original dataset: {len(df)} restaurants")
    
    # Create a function to extract city from address
    def extract_city(address):
        if pd.isna(address):
            return "Unknown"
        
        address_str = str(address)
        
        # Common Toronto area cities to look for
        cities = [
            "Toronto", "Scarborough", "Etobicoke", "North York", 
            "East York", "York", "Mississauga", "Brampton", "Markham",
            "Richmond Hill", "Vaughan", "Pickering", "Ajax", "Whitby",
            "Oshawa", "Burlington", "Oakville", "Hamilton", "Kitchener",
            "Waterloo", "Cambridge", "Guelph", "Barrie", "Newmarket"
        ]
        
        # Check for each city in the address
        for city in cities:
            if city.lower() in address_str.lower():
                return city
        
        return "Other"
    
    # Extract cities for all restaurants
    print("Categorizing restaurants by city...")
    df['City'] = df['Restaurant Address'].apply(extract_city)
    
    # Get city counts
    city_counts = df['City'].value_counts()
    
    print(f"\nRestaurant distribution by city:")
    print("-" * 40)
    for city, count in city_counts.items():
        print(f"{city:20}: {count:5} restaurants")
    
    # Create output directory
    output_dir = "restaurants_by_city"
    os.makedirs(output_dir, exist_ok=True)
    
    # Save separate CSV files for each city
    print(f"\nSaving separate CSV files for each city...")
    
    for city in city_counts.index:
        if city_counts[city] > 0:  # Only save cities with restaurants
            city_df = df[df['City'] == city]
            filename = f"{city.lower().replace(' ', '_')}_restaurants.csv"
            filepath = os.path.join(output_dir, filename)
            city_df.to_csv(filepath, index=False)
            print(f"  {city}: {len(city_df)} restaurants -> {filename}")
    
    print(f"\n✅ Categorization complete!")
    print(f"All files saved in '{output_dir}' directory")
    
    return df, city_counts

def show_sample_data_by_city(df, city_counts, n=3):
    """Show sample data for each city"""
    print(f"\nSample restaurants from each city:")
    print("=" * 80)
    
    for city in city_counts.head(10).index:  # Show top 10 cities
        city_df = df[df['City'] == city]
        print(f"\n{city} ({len(city_df)} restaurants):")
        print("-" * 40)
        
        for i, (_, row) in enumerate(city_df.head(n).iterrows()):
            print(f"  {i+1}. {row['Restaurant Name']}")
            print(f"     Address: {row['Restaurant Address']}")
            print(f"     Category: {row['Category']}")
            print()

if __name__ == "__main__":
    # Categorize restaurants by city
    df, city_counts = categorize_restaurants_by_city()
    
    # Show sample data
    show_sample_data_by_city(df, city_counts)
    
    print(f"\nTotal restaurants processed: {len(df)}")
    print(f"Number of different cities: {len(city_counts)}")
    print(f"Files saved in 'restaurants_by_city' directory")
