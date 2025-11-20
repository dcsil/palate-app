# Google Places API - Portrait Photo Testing

A focused Python project to test Google Places API for generating high-resolution portrait images, perfect for TikTok-like platforms and vertical content.

## Setup

1. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Get a Google Places API key:**
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create a new project or select an existing one
   - Enable the Places API
   - Create credentials (API key)
   - Restrict the API key to Places API for security

3. **Set up environment variables:**
   - Create a `.env` file in this directory
   - Add your API key:
     ```
     GOOGLE_PLACES_API_KEY=your_actual_api_key_here
     ```

## Usage

### Portrait Photo Testing
Run the main portrait photo testing script:

```bash
python main.py
```

### Test Specific Places
Test portrait photos for specific places with different aspect ratios:

```bash
# TikTok format (9:16 aspect ratio)
python main.py tiktok "Eiffel Tower Paris"

# Instagram format (4:5 aspect ratio)
python main.py instagram "Times Square New York"

# YouTube Shorts format (9:16 aspect ratio)
python main.py youtube "Golden Gate Bridge"
```

## What it tests

The script focuses specifically on:

1. **Portrait Photo Filtering** - Downloads only vertical/tall images
2. **Aspect Ratio Control** - Filters photos by specific aspect ratios for different platforms
3. **High Resolution** - Ensures downloaded photos meet minimum quality requirements
4. **Platform-Specific Formats** - Supports TikTok, Instagram, YouTube Shorts formats
5. **Photo Collages** - Creates portrait-oriented collages from downloaded photos

## Example Output

```
📱 Testing Google Places API - Portrait Photos for TikTok-like Platform
======================================================================

🔍 Search 1: Terroni - Adelaide in Toronto
--------------------------------------------------
📍 Found: Terroni - Adelaide
📷 Total photos available: 8
📸 Downloading 3 high-quality photos for: Terroni - Adelaide
   Quality filter: min 400x600 pixels
   Portrait filter: aspect ratio 0.5-0.8 (vertical images)
--------------------------------------------------

Photo 1/3:
   Original size: 1200x1600
   Download size: 600x800
✅ Downloaded photo: photo_AciIO2cKa3.jpg
   Size: 600x800 pixels
   Saved to: photos/photo_AciIO2cKa3.jpg

Photo 2/3:
   Original size: 800x1200
   Download size: 600x800
✅ Downloaded photo: photo_AciIO2cn_e.jpg
   Size: 600x800 pixels
   Saved to: photos/photo_AciIO2cn_e.jpg

✅ Downloaded 3 portrait photos

🎨 Creating Portrait Collage for TikTok-like Platform
============================================================
Total portrait photos: 3
✅ Created photo collage: photos/portrait_collage.jpg
   Dimensions: 1200x400
   Images: 3

📁 Portrait photos saved in the 'photos' directory
   - Individual photos: photo_*.jpg (all portrait orientation)
   - Portrait collage: portrait_collage.jpg
   - Perfect for TikTok, Instagram Stories, YouTube Shorts!

======================================================================
🎉 Portrait photo testing completed!
```

## Platform-Specific Aspect Ratios

The script supports different aspect ratios for various platforms:

- **TikTok**: 0.5-0.6 (9:16 to 3:5 ratio) - Very tall, full screen
- **Instagram Story**: 0.56 (9:16 ratio) - Full screen story
- **Instagram Post**: 0.6-0.8 (4:5 to 3:4 ratio) - Square-ish, tall
- **YouTube Shorts**: 0.5-0.7 (9:16 to 7:10 ratio) - Vertical video
- **Pinterest Pin**: 0.75 (3:4 ratio) - Tall pin format

## Troubleshooting

- **API Key Error**: Make sure your API key is correctly set in the `.env` file
- **Quota Exceeded**: Check your Google Cloud Console for API usage limits
- **Permission Denied**: Ensure the Places API is enabled for your project
- **Invalid Request**: Verify your API key has the correct permissions

## API Costs

Be aware that Google Places API has usage costs. Check the [pricing page](https://developers.google.com/maps/billing-and-pricing/pricing) for current rates.
