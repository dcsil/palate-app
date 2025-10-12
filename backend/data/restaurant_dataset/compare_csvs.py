#!/usr/bin/env python3
"""
Compare two CSV files to identify differences
"""

import pandas as pd

def compare_csvs(file1="toronto_restaurants_processed.csv", file2="tor_res_20251011.csv"):
    """
    Compare two CSV files and show differences
    
    Args:
        file1 (str): First CSV file (output from process_restaurant_data)
        file2 (str): Second CSV file (correct file)
    """
    
    print(f"Loading {file1}...")
    df1 = pd.read_csv(file1)
    print(f"File 1 ({file1}): {len(df1)} rows")
    
    print(f"Loading {file2}...")
    df2 = pd.read_csv(file2)
    print(f"File 2 ({file2}): {len(df2)} rows")
    
    print(f"\nRow count difference: {len(df1) - len(df2)}")
    
    # Check if columns are the same
    print(f"\nColumn comparison:")
    print(f"File 1 columns: {list(df1.columns)}")
    print(f"File 2 columns: {list(df2.columns)}")
    
    if list(df1.columns) == list(df2.columns):
        print("✅ Columns match")
    else:
        print("❌ Columns differ")
        cols1_set = set(df1.columns)
        cols2_set = set(df2.columns)
        print(f"Only in file 1: {cols1_set - cols2_set}")
        print(f"Only in file 2: {cols2_set - cols1_set}")
    
    # Compare restaurant names
    print(f"\nRestaurant name comparison:")
    names1 = set(df1['Restaurant Name'].str.lower().str.strip())
    names2 = set(df2['Restaurant Name'].str.lower().str.strip())
    
    only_in_file1 = names1 - names2
    only_in_file2 = names2 - names1
    common_names = names1 & names2
    
    print(f"Restaurants only in {file1}: {len(only_in_file1)}")
    print(f"Restaurants only in {file2}: {len(only_in_file2)}")
    print(f"Common restaurants: {len(common_names)}")
    
    # Show sample differences
    if only_in_file1:
        print(f"\nSample restaurants only in {file1}:")
        for name in list(only_in_file1)[:10]:
            print(f"  - {name}")
        if len(only_in_file1) > 10:
            print(f"  ... and {len(only_in_file1) - 10} more")
    
    if only_in_file2:
        print(f"\nSample restaurants only in {file2}:")
        for name in list(only_in_file2)[:10]:
            print(f"  - {name}")
        if len(only_in_file2) > 10:
            print(f"  ... and {len(only_in_file2) - 10} more")
    
    # Check for specific restaurants that should be removed
    print(f"\nChecking for restaurants that should be removed:")
    remove_list = [
        "tim hortons", "starbucks", "mcdonald's", "subway", "pizza pizza",
        "kfc", "burger king", "wendy's", "domino's", "pizza hut"
    ]
    
    for restaurant in remove_list:
        in_file1 = restaurant in names1
        in_file2 = restaurant in names2
        print(f"  {restaurant}: File1={in_file1}, File2={in_file2}")
    
    # Address comparison
    print(f"\nAddress comparison:")
    addresses1 = set(df1['Restaurant Address'].str.lower().str.strip())
    addresses2 = set(df2['Restaurant Address'].str.lower().str.strip())
    
    only_addr1 = addresses1 - addresses2
    only_addr2 = addresses2 - addresses1
    
    print(f"Addresses only in {file1}: {len(only_addr1)}")
    print(f"Addresses only in {file2}: {len(only_addr2)}")
    
    # Show sample address differences
    if only_addr1:
        print(f"\nSample addresses only in {file1}:")
        for addr in list(only_addr1)[:5]:
            print(f"  - {addr}")
    
    if only_addr2:
        print(f"\nSample addresses only in {file2}:")
        for addr in list(only_addr2)[:5]:
            print(f"  - {addr}")
    
    return {
        'file1_rows': len(df1),
        'file2_rows': len(df2),
        'only_in_file1': only_in_file1,
        'only_in_file2': only_in_file2,
        'common_names': common_names
    }

if __name__ == "__main__":
    print("=" * 80)
    print("CSV COMPARISON TOOL")
    print("=" * 80)
    
    results = compare_csvs()
    
    print(f"\n" + "=" * 80)
    print("SUMMARY:")
    print(f"  File 1 (processed): {results['file1_rows']} rows")
    print(f"  File 2 (correct): {results['file2_rows']} rows")
    print(f"  Difference: {results['file1_rows'] - results['file2_rows']} rows")
    print(f"  Only in file 1: {len(results['only_in_file1'])} restaurants")
    print(f"  Only in file 2: {len(results['only_in_file2'])} restaurants")
    print(f"  Common: {len(results['common_names'])} restaurants")
    print("=" * 80)
