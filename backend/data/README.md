# Restaurant Data Management

This directory contains scripts and data for managing restaurant information.

## 📁 Directory Structure

```
data/
├── scripts/           # Python scripts for data processing
├── data/
│   ├── raw/          # Original, unprocessed data files
│   ├── processed/    # Cleaned and processed data files
│   └── exports/      # Exported data files
├── config/           # Configuration files (Firebase keys, etc.)
└── README.md         # This file
```

## 🚀 Quick Start

### 1. Extract Restaurant Data
```bash
cd scripts
python extract_columns.py
```
This creates a filtered CSV with only the essential restaurant columns.

### 2. Upload to Firebase
```bash
cd scripts
pip install -r requirements.txt
python upload_to_firebase.py
```
This uploads the restaurant data to your Firebase Firestore database.

### 3. Test Data Reading
```bash
cd scripts
python test_csv_reading.py
```
This verifies the data structure and shows statistics.

## 📊 Data Files

- **Raw Data**: `data/raw/tor_res_20251011_enriched_combined.csv` - Original restaurant dataset
- **Processed Data**: `data/processed/restaurant_data_filtered.csv` - Cleaned data with essential columns
- **Firebase Config**: `config/firebase-service-account.json` - Firebase authentication key

## 🔧 Scripts

- **`extract_columns.py`** - Extracts and cleans restaurant data
- **`upload_to_firebase.py`** - Uploads data to Firebase Firestore
- **`test_csv_reading.py`** - Tests and validates data structure

## 📋 Data Schema

Each restaurant record contains:
- `category` - Restaurant category (e.g., "Asian Fusion")
- `name` - Restaurant name
- `price_range` - Price level (1-4: Under $10 to Above $61)
- `google_place_id` - Google Places API ID
- `formatted_address` - Full address
- `latitude` / `longitude` - GPS coordinates
- `google_types` - Array of place types
- `created_at` - Timestamp

## ⚙️ Setup

1. Place your Firebase service account key in `config/firebase-service-account.json`
2. Install dependencies: `pip install -r scripts/requirements.txt`
3. Run the scripts from the `scripts/` directory
