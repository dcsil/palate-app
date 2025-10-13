#!/usr/bin/env python3
"""
Script to extract specific columns from the restaurant dataset CSV file.
Creates a new CSV with only the following columns:
- Category
- Restaurant Name
- Restaurant Price Range
- google_place_id
- google_formatted_address
- google_lat
- google_lng
- google_types
"""

import csv
import os

def convert_price_range_to_int(price_text):
    """
    Convert price range text to integer (1-4).
    1 = Under $10
    2 = $11-30
    3 = $31-60
    4 = Above $61
    """
    if not price_text or price_text.strip() == '':
        return ''
    
    price_text = price_text.strip()
    
    if 'Under $10' in price_text:
        return '1'
    elif '$11-30' in price_text:
        return '2'
    elif '$31-60' in price_text:
        return '3'
    elif 'Above $61' in price_text:
        return '4'
    else:
        # If price format is unknown, return original text
        return price_text

def extract_restaurant_columns():
    """
    Extract specific columns from the restaurant dataset and save to a new CSV file.
    """
    # Input and output file paths
    input_file = "../data/raw/tor_res_20251011_enriched_combined.csv"
    output_file = "../data/processed/restaurant_data_filtered.csv"
    
    # Check if input file exists
    if not os.path.exists(input_file):
        print(f"Error: Input file '{input_file}' not found!")
        return
    
    try:
        # Define the columns to extract
        columns_to_extract = [
            'Category',
            'Restaurant Name', 
            'Restaurant Price Range',
            'google_place_id',
            'google_formatted_address',
            'google_lat',
            'google_lng',
            'google_types'
        ]
        
        # Define the output column names (with price as integer)
        output_columns = [
            'Category',
            'Restaurant Name', 
            'Price_Range_Int',
            'google_place_id',
            'google_formatted_address',
            'google_lat',
            'google_lng',
            'google_types'
        ]
        
        print(f"Reading data from {input_file}...")
        
        # Read the input CSV and extract specified columns
        with open(input_file, 'r', encoding='utf-8') as infile:
            reader = csv.DictReader(infile)
            
            # Check if all required columns exist
            available_columns = reader.fieldnames
            missing_columns = [col for col in columns_to_extract if col not in available_columns]
            
            if missing_columns:
                print(f"Error: The following columns are missing from the dataset:")
                for col in missing_columns:
                    print(f"  - {col}")
                print(f"\nAvailable columns are:")
                for col in available_columns:
                    print(f"  - {col}")
                return
            
            # Get column indices for faster access
            column_indices = [available_columns.index(col) for col in columns_to_extract]
            
            # Read all rows and extract the specified columns
            rows = []
            for row in reader:
                extracted_row = []
                for col in columns_to_extract:
                    if col == 'Restaurant Price Range':
                        # Convert price range to integer
                        extracted_row.append(convert_price_range_to_int(row[col]))
                    else:
                        extracted_row.append(row[col])
                rows.append(extracted_row)
        
        print(f"Extracting {len(columns_to_extract)} columns from {len(rows)} rows...")
        
        # Write the filtered data to output CSV
        print(f"Saving filtered data to {output_file}...")
        with open(output_file, 'w', newline='', encoding='utf-8') as outfile:
            writer = csv.writer(outfile)
            
            # Write header
            writer.writerow(output_columns)
            
            # Write data rows
            writer.writerows(rows)
        
        # Print summary
        print(f"\nSuccess! Created {output_file} with {len(rows)} rows and {len(output_columns)} columns:")
        for col in output_columns:
            print(f"  - {col}")
        
        # Show first few rows as preview
        print(f"\nPreview of the first 5 rows:")
        print(f"Header: {', '.join(output_columns)}")
        for i, row in enumerate(rows[:5]):
            print(f"Row {i+1}: {', '.join(str(cell) for cell in row)}")
        
        # Show price conversion mapping
        print(f"\nPrice Range Conversion:")
        print(f"  1 = Under $10")
        print(f"  2 = $11-30") 
        print(f"  3 = $31-60")
        print(f"  4 = Above $61")
        
    except Exception as e:
        print(f"Error processing the file: {str(e)}")

if __name__ == "__main__":
    extract_restaurant_columns()
