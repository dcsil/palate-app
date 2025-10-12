#!/usr/bin/env python3
"""
Split tor_res_20251011.csv into smaller CSV files with 100 restaurants each
"""

import pandas as pd
import os
import math

def split_csv(input_file="TOR_RES_20251011.csv", chunk_size=1000, output_dir="restaurant_chunks"):
    """
    Split a CSV file into smaller chunks
    
    Args:
        input_file (str): Input CSV file name
        chunk_size (int): Number of rows per chunk
        output_dir (str): Output directory for chunks
    """
    
    print(f"Loading {input_file}...")
    df = pd.read_csv(input_file)
    total_rows = len(df)
    
    print(f"Total restaurants: {total_rows}")
    print(f"Chunk size: {chunk_size}")
    
    # Calculate number of chunks needed
    num_chunks = math.ceil(total_rows / chunk_size)
    print(f"Number of chunks to create: {num_chunks}")
    
    # Create output directory
    os.makedirs(output_dir, exist_ok=True)
    print(f"Output directory: {output_dir}")
    
    # Split the dataframe into chunks
    print(f"\nCreating chunks...")
    
    for i in range(num_chunks):
        start_idx = i * chunk_size
        end_idx = min((i + 1) * chunk_size, total_rows)
        
        # Get chunk
        chunk_df = df.iloc[start_idx:end_idx]
        
        # Create filename
        chunk_filename = f"restaurant_chunk_{i+1:03d}.csv"
        chunk_path = os.path.join(output_dir, chunk_filename)
        
        # Save chunk
        chunk_df.to_csv(chunk_path, index=False)
        
        print(f"  Chunk {i+1:3d}: rows {start_idx+1:4d}-{end_idx:4d} -> {chunk_filename}")
    
    print(f"\n✅ Splitting complete!")
    print(f"Created {num_chunks} files in '{output_dir}' directory")
    
    # Show file sizes
    print(f"\nFile sizes:")
    total_size = 0
    for i in range(num_chunks):
        chunk_filename = f"restaurant_chunk_{i+1:03d}.csv"
        chunk_path = os.path.join(output_dir, chunk_filename)
        file_size = os.path.getsize(chunk_path)
        total_size += file_size
        print(f"  {chunk_filename}: {file_size:,} bytes")
    
    print(f"Total size: {total_size:,} bytes")
    
    return num_chunks

def verify_chunks(output_dir="restaurant_chunks", original_file="tor_res_20251011.csv"):
    """
    Verify that all chunks together contain the same data as the original file
    """
    
    print(f"\nVerifying chunks...")
    
    # Load original file
    df_original = pd.read_csv(original_file)
    original_rows = len(df_original)
    
    # Load all chunks
    chunk_files = sorted([f for f in os.listdir(output_dir) if f.startswith('restaurant_chunk_')])
    
    all_chunks = []
    for chunk_file in chunk_files:
        chunk_path = os.path.join(output_dir, chunk_file)
        chunk_df = pd.read_csv(chunk_path)
        all_chunks.append(chunk_df)
    
    # Combine all chunks
    df_combined = pd.concat(all_chunks, ignore_index=True)
    combined_rows = len(df_combined)
    
    print(f"Original rows: {original_rows}")
    print(f"Combined rows: {combined_rows}")
    print(f"Match: {'✅' if original_rows == combined_rows else '❌'}")
    
    if original_rows == combined_rows:
        print("✅ All chunks verified successfully!")
    else:
        print("❌ Verification failed - row counts don't match")

if __name__ == "__main__":
    print("=" * 60)
    print("CSV SPLITTING TOOL")
    print("=" * 60)
    
    # Split the CSV file
    num_chunks = split_csv()
    
    # Verify the chunks
    verify_chunks()
    
    print(f"\n" + "=" * 60)
    print("SUMMARY:")
    print(f"  Input file: tor_res_20251011.csv")
    print(f"  Chunk size: 100 restaurants")
    print(f"  Output directory: restaurant_chunks/")
    print(f"  Number of chunks: {num_chunks}")
    print("=" * 60)
