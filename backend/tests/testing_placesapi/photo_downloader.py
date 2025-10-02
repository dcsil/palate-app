#!/usr/bin/env python3
"""
Photo downloader utility for Google Places API photos
"""

import os
import requests
from config import GOOGLE_PLACES_API_KEY

def download_place_photo(photo_reference, max_width=400, max_height=400, output_dir="photos"):
    """
    Download a photo from Google Places API using photo reference
    
    Args:
        photo_reference (str): The photo reference from Places API
        max_width (int): Maximum width of the photo
        max_height (int): Maximum height of the photo
        output_dir (str): Directory to save the photo
    
    Returns:
        str: Path to the downloaded photo, or None if failed
    """
    try:
        # Create output directory if it doesn't exist
        os.makedirs(output_dir, exist_ok=True)
        
        # Build the photo URL
        photo_url = f"https://maps.googleapis.com/maps/api/place/photo?maxwidth={max_width}&maxheight={max_height}&photoreference={photo_reference}&key={GOOGLE_PLACES_API_KEY}"
        
        # Download the photo
        response = requests.get(photo_url)
        response.raise_for_status()
        
        # Generate filename
        filename = f"photo_{photo_reference[:10]}.jpg"
        filepath = os.path.join(output_dir, filename)
        
        # Save the photo
        with open(filepath, 'wb') as f:
            f.write(response.content)
        
        return filepath
        
    except requests.exceptions.RequestException:
        return None
    except Exception:
        return None

def download_place_photos(place_details, max_photos=3, max_width=400, max_height=400, min_width=300, min_height=300, portrait_only=False, min_aspect_ratio=0.6, max_aspect_ratio=0.8):
    """
    Download multiple photos from a place's details with quality and aspect ratio filtering
    
    Args:
        place_details (dict): Place details from Places API
        max_photos (int): Maximum number of photos to download
        max_width (int): Maximum width of each photo
        max_height (int): Maximum height of each photo
        min_width (int): Minimum width required for photo quality
        min_height (int): Minimum height required for photo quality
        portrait_only (bool): If True, only download portrait (vertical) images
        min_aspect_ratio (float): Minimum aspect ratio (width/height) for portrait filtering
        max_aspect_ratio (float): Maximum aspect ratio (width/height) for portrait filtering
    
    Returns:
        list: List of downloaded photo filepaths
    """
    downloaded_photos = []
    
    if 'photos' not in place_details:
        return downloaded_photos
    
    # Filter photos by minimum resolution and aspect ratio
    quality_photos = []
    for photo in place_details['photos']:
        width = photo.get('width', 0)
        height = photo.get('height', 0)
        
        # Check if photo meets minimum quality requirements
        if width < min_width or height < min_height:
            continue
        
        # Check aspect ratio for portrait filtering
        if portrait_only:
            aspect_ratio = width / height if height > 0 else 0
            if aspect_ratio < min_aspect_ratio or aspect_ratio > max_aspect_ratio:
                continue
        
        quality_photos.append(photo)
    
    if not quality_photos:
        return downloaded_photos
    
    # Limit to max_photos
    photos = quality_photos[:max_photos]
    
    for photo in photos:
        photo_reference = photo['photo_reference']
        
        # Get photo dimensions
        width = photo.get('width', max_width)
        height = photo.get('height', max_height)
        
        # Use the smaller dimension to avoid oversized downloads
        actual_width = min(width, max_width)
        actual_height = min(height, max_height)
        
        filepath = download_place_photo(
            photo_reference, 
            max_width=actual_width, 
            max_height=actual_height
        )
        
        if filepath:
            downloaded_photos.append(filepath)
    
    return downloaded_photos
