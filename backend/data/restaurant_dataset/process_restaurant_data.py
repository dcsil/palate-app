#!/usr/bin/env python3
"""
Complete restaurant data processing pipeline:
1. Filter restaurants by city
2. Find restaurant chains
3. Remove unwanted restaurants
"""

import pandas as pd
import os
import ast

def filter_toronto_restaurants(input_file="trt_rest.csv"):
    """
    Filter restaurants to only include those in Toronto, ON (not other areas)
    
    Args:
        input_file (str): Input CSV file name
    """
    
    print(f"Step 1: Loading data from {input_file}...")
    df = pd.read_csv(input_file)
    print(f"Original dataset: {len(df)} restaurants")
    
    # Filter for Toronto, ON only (not Scarborough, Etobicoke, North York)
    print("Filtering for Toronto, ON restaurants only...")
    toronto_df = df[df['Restaurant Address'].str.contains('Toronto, ON', case=False, na=False)]
    
    print(f"Toronto restaurants: {len(toronto_df)}")
    print(f"Removed: {len(df) - len(toronto_df)} restaurants")
    
    return toronto_df

def remove_duplicates(df):
    """
    Remove duplicates based on restaurant name and address
    
    Args:
        df (DataFrame): Restaurant dataframe
    """
    
    print(f"\nStep 2: Removing duplicates...")
    print(f"Before deduplication: {len(df)} restaurants")
    
    # Remove duplicates based on name and address
    df_unique = df.drop_duplicates(subset=['Restaurant Name', 'Restaurant Address'])
    
    print(f"After deduplication: {len(df_unique)} restaurants")
    print(f"Removed {len(df) - len(df_unique)} duplicates")
    
    return df_unique


def remove_unwanted_restaurants(df, remove_file="remove_list.csv"):
    """
    Remove restaurants listed in remove_list.csv
    
    Args:
        df (DataFrame): Restaurant dataframe
        remove_file (str): CSV file with restaurants to remove
    """
    
    print(f"\nStep 3: Removing unwanted restaurants...")
    
    if not os.path.exists(remove_file):
        print(f"Remove list file '{remove_file}' not found. Skipping removal step.")
        return df, 0
    
    print(f"Loading remove list from {remove_file}...")
    df_remove = pd.read_csv(remove_file)
    print(f"Restaurants to remove: {len(df_remove)}")
    
    # Create a set of all restaurant names to remove (including aliases)
    names_to_remove = set()
    
    for _, row in df_remove.iterrows():
        main_name = row['name'].strip().lower()
        names_to_remove.add(main_name)
        
        # Parse aliases if they exist
        if pd.notna(row['aliases']) and row['aliases'].strip() and row['aliases'] != '[]':
            try:
                aliases = ast.literal_eval(row['aliases'])
                for alias in aliases:
                    names_to_remove.add(alias.strip().lower())
            except Exception as e:
                print(f"Warning: Could not parse aliases for {row['name']}: {e}")
    
    print(f"Total names/aliases to remove: {len(names_to_remove)}")
    
    # Show some names that will be removed
    print(f"Sample names to remove: {list(list(names_to_remove)[:10])}")
    
    # Create a function to check if a restaurant should be removed
    def should_remove_restaurant(restaurant_name):
        if pd.isna(restaurant_name):
            return False
        return restaurant_name.strip().lower() in names_to_remove
    
    # Filter out restaurants to remove
    print("Filtering out restaurants...")
    df_filtered = df[~df['Restaurant Name'].apply(should_remove_restaurant)]
    
    removed_count = len(df) - len(df_filtered)
    print(f"Removed {removed_count} restaurants")
    print(f"Remaining restaurants: {len(df_filtered)}")
    
    # Show some examples of what was removed
    if removed_count > 0:
        print(f"\nExamples of removed restaurants:")
        removed_restaurants = df[df['Restaurant Name'].apply(should_remove_restaurant)]
        removed_names = removed_restaurants['Restaurant Name'].value_counts().head(10)
        
        for name, count in removed_names.items():
            print(f"  {name}: {count} locations")
    else:
        print("No restaurants were removed.")
    
    return df_filtered, removed_count

def main():
    """Main processing pipeline"""
    
    print("=" * 80)
    print("RESTAURANT DATA PROCESSING PIPELINE")
    print("=" * 80)
    
    # Step 1: Filter for Toronto only
    df_toronto = filter_toronto_restaurants()
    
    # Step 2: Remove duplicates
    df_unique = remove_duplicates(df_toronto)
    
    # Step 3: Remove chains from remove_list.csv
    df_final, removed_count = remove_unwanted_restaurants(df_unique)
    
    # Save final dataset
    output_file = "toronto_restaurants_processed.csv"
    print(f"\nSaving final processed dataset to {output_file}...")
    df_final.to_csv(output_file, index=False)
    
    # Final summary
    print(f"\n" + "=" * 80)
    print(f"PROCESSING COMPLETE!")
    print(f"=" * 80)
    print(f"Original restaurants: {len(pd.read_csv('trt_rest.csv')):,}")
    print(f"After Toronto filtering: {len(df_toronto):,}")
    print(f"After removing duplicates: {len(df_unique):,}")
    print(f"After removing chains: {len(df_final):,}")
    print(f"Total removed: {len(pd.read_csv('trt_rest.csv')) - len(df_final):,}")
    print(f"Chains removed: {removed_count}")
    print(f"Final dataset saved as: {output_file}")
    print(f"=" * 80)

if __name__ == "__main__":
    main()
