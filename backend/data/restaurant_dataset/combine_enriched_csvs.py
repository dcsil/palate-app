#!/usr/bin/env python3
"""
Combine enriched CSV files back into one file
"""

import pandas as pd
import os
import glob

def combine_enriched_csvs(input_pattern="restaurant_chunk_*_enriched*.csv", output_file="tor_res_20251011_enriched_combined.csv"):
    """
    Combine all enriched CSV files into one file
    
    Args:
        input_pattern (str): Pattern to match enriched CSV files
        output_file (str): Output combined CSV file name
    """
    
    print(f"Looking for enriched CSV files matching pattern: {input_pattern}")
    
    # Find all enriched CSV files
    enriched_files = glob.glob(input_pattern)
    
    if not enriched_files:
        print("❌ No enriched CSV files found!")
        return None
    
    # Sort files to ensure consistent order
    enriched_files.sort()
    
    print(f"Found {len(enriched_files)} enriched CSV files:")
    for i, file in enumerate(enriched_files, 1):
        print(f"  {i:2d}. {file}")
    
    # Load and combine all files
    print(f"\nLoading and combining files...")
    
    all_dataframes = []
    total_rows = 0
    
    for i, file in enumerate(enriched_files, 1):
        print(f"  Loading {file}...")
        try:
            df = pd.read_csv(file)
            all_dataframes.append(df)
            total_rows += len(df)
            print(f"    Rows: {len(df)}")
        except Exception as e:
            print(f"    ❌ Error loading {file}: {e}")
            continue
    
    if not all_dataframes:
        print("❌ No valid dataframes loaded!")
        return None
    
    # Combine all dataframes
    print(f"\nCombining {len(all_dataframes)} dataframes...")
    combined_df = pd.concat(all_dataframes, ignore_index=True)
    
    print(f"Combined total rows: {len(combined_df)}")
    print(f"Expected total rows: {total_rows}")
    
    # Check for duplicates
    print(f"\nChecking for duplicates...")
    duplicates = combined_df.duplicated().sum()
    print(f"Duplicate rows: {duplicates}")
    
    if duplicates > 0:
        print("Removing duplicates...")
        combined_df = combined_df.drop_duplicates()
        print(f"After removing duplicates: {len(combined_df)} rows")
    
    # Save combined file
    print(f"\nSaving combined file to {output_file}...")
    combined_df.to_csv(output_file, index=False)
    
    # Get file size
    file_size = os.path.getsize(output_file)
    print(f"File size: {file_size:,} bytes ({file_size/1024/1024:.1f} MB)")
    
    # Show sample of combined data
    print(f"\nSample of combined data:")
    print("-" * 80)
    print(combined_df.head())
    
    # Show column info
    print(f"\nColumns in combined file:")
    for i, col in enumerate(combined_df.columns, 1):
        print(f"  {i:2d}. {col}")
    
    print(f"\n✅ Combination complete!")
    print(f"Combined file saved as: {output_file}")
    
    return combined_df

def verify_combination(combined_file, original_files):
    """
    Verify that the combination preserved all data
    """
    
    print(f"\nVerifying combination...")
    
    # Load combined file
    df_combined = pd.read_csv(combined_file)
    combined_rows = len(df_combined)
    
    # Count rows in original files
    original_rows = 0
    for file in original_files:
        try:
            df = pd.read_csv(file)
            original_rows += len(df)
        except:
            continue
    
    print(f"Original files total rows: {original_rows}")
    print(f"Combined file rows: {combined_rows}")
    print(f"Match: {'✅' if original_rows == combined_rows else '❌'}")
    
    if original_rows == combined_rows:
        print("✅ Verification successful - all data preserved!")
    else:
        print("❌ Verification failed - row counts don't match")

if __name__ == "__main__":
    print("=" * 80)
    print("ENRICHED CSV COMBINATION TOOL")
    print("=" * 80)
    
    # Combine enriched CSV files
    combined_df = combine_enriched_csvs()
    
    if combined_df is not None:
        # Find original files for verification
        original_files = glob.glob("restaurant_chunk_*_enriched*.csv")
        if original_files:
            verify_combination("tor_res_20251011_enriched_combined.csv", original_files)
        
        print(f"\n" + "=" * 80)
        print("SUMMARY:")
        print(f"  Input files: {len(original_files)} enriched CSV files")
        print(f"  Output file: tor_res_20251011_enriched_combined.csv")
        print(f"  Total rows: {len(combined_df)}")
        print(f"  Columns: {len(combined_df.columns)}")
        print("=" * 80)
    else:
        print("❌ Combination failed!")
