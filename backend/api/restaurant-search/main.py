"""
FastAPI application for restaurant search with Google Places API and Firebase integration
Optimized for Cloud Run deployment
"""
import os
import asyncio
from fastapi import FastAPI, Request, HTTPException, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from dotenv import load_dotenv
from models import GeoPoint, LocationResponse, RestaurantSearchRequest, RestaurantSearchResponse, Restaurant, RestaurantDetailsRequest, RestaurantDetailsResponse, MultipleRestaurantDetailsRequest, MultipleRestaurantDetailsResponse, RestaurantDetailsItem, DeleteRestaurantRequest, DeleteRestaurantResponse
from places_service import places_service
from firebase_service import get_firebase_service

# Load environment variables
load_dotenv()

# Background task function for updating restaurant details
async def update_restaurant_details_background(place_id: str):
    """
    Background task to update restaurant details in Firebase.
    This runs after the API response is sent to the frontend.
    Note: This only runs when fresh data was fetched from Google Places API.
    """
    try:
        firebase_service = get_firebase_service()
        
        print(f"Background task: Updating Firebase with fresh data for place_id: {place_id}")
        
        # Get fresh details from Google Places API
        details = await places_service.get_restaurant_details(place_id)
        
        # Update Firebase with fresh details
        success = await firebase_service.update_restaurant_details(place_id, details)
        
        if success:
            print(f"Successfully updated restaurant details for place_id: {place_id}")
        else:
            print(f"Failed to update restaurant details for place_id: {place_id}")
            
    except Exception as e:
        print(f"Error in background update for place_id {place_id}: {str(e)}")


async def get_single_restaurant_details(place_id: str, firebase_service) -> tuple[str, dict, str]:
    """
    Get restaurant details for a single place_id with caching logic.
    Returns (place_id, details_dict, data_source)
    """
    import time
    start_time = time.time()
    
    try:
        # First, try to get details from Firebase if they exist and are fresh
        details = await firebase_service.get_restaurant_details_from_firebase(place_id)
        
        if details:
            # Data exists in Firebase and is fresh, use it
            elapsed = round((time.time() - start_time) * 1000, 1)
            print(f"[{elapsed}ms] Using fresh data from Firebase for place_id: {place_id}")
            return place_id, details, "firebase"
        else:
            # Data doesn't exist or is stale, fetch from Google Places API
            print(f"[START] Fetching fresh data from Google Places API for place_id: {place_id}")
            details = await places_service.get_restaurant_details(place_id)
            elapsed = round((time.time() - start_time) * 1000, 1)
            print(f"[{elapsed}ms] Completed Google Places API fetch for place_id: {place_id}")
            return place_id, details, "google_places"
            
    except Exception as e:
        elapsed = round((time.time() - start_time) * 1000, 1)
        print(f"[{elapsed}ms] Error getting details for place_id {place_id}: {str(e)}")
        # Return empty details with error info
        return place_id, {}, f"error: {str(e)}"

# Create FastAPI app with Cloud Run optimizations
app = FastAPI(
    title="Restaurant Search API",
    version="1.0.0",
    description="A FastAPI application for restaurant search with Google Places API and Firebase integration",
    docs_url="/docs",
    redoc_url="/redoc"
)

# CORS middleware configuration for Cloud Run
# Allow specific origins for security
origins = [
    "http://localhost:3000",        # Local development
    "http://localhost:8000",        # FastAPI docs
    "https://preview.flutterflow.app",  # FlutterFlow preview
    "https://palate-cve8jj.flutterflow.app",  # Your FlutterFlow app
    # Add your production domains here
]

# For development, allow all localhost ports (FlutterFlow dynamic ports)
if os.getenv("ENVIRONMENT") == "development":
    # Use wildcard for complete flexibility during development
    # This covers any localhost port that FlutterFlow might use
    origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allow_headers=["*"],
    expose_headers=["*"],
)

# Global exception handler for Cloud Run
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    return JSONResponse(
        status_code=500,
        content={
            "error": "Internal server error",
            "message": "An unexpected error occurred",
            "path": str(request.url)
        }
    )

# Health check endpoint (required for Cloud Run)
@app.get("/")
async def root():
    return {
        "message": "Restaurant Search API is running",
        "version": "1.0.0",
        "status": "healthy"
    }

@app.get("/health")
async def health():
        return {
        "status": "ok",
        "service": "restaurant-search-api"
    }

# Readiness check for Cloud Run
@app.get("/ready")
async def readiness():
                return {
        "status": "ready",
        "service": "restaurant-search-api"
    }

# Location information endpoint
@app.post("/location", response_model=LocationResponse)
async def get_location_info(geopoint: GeoPoint):
    """
    Get neighborhood name and city information from coordinates using reverse geocoding.
    
    This endpoint uses Google's Geocoding API to convert latitude and longitude 
    coordinates to neighborhood and city information.
    """
    try:
        # Get location information from Google Places API
        location_data = await places_service.get_location_info(
            latitude=geopoint.latitude,
            longitude=geopoint.longitude
        )
        
        return LocationResponse(
            success=True,
            neighborhood=location_data.get("neighborhood"),
            city=location_data.get("city"),
                    error=None
        )
        
    except ValueError as e:
        # API key missing or invalid coordinates
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        # Other errors (API errors, network issues, etc.)
        print(f"Error in location endpoint: {str(e)}")
        raise HTTPException(status_code=500, detail="Failed to retrieve location information")


# Restaurant search endpoint with GeoPoint + geohash pattern
@app.post("/restaurants/search", response_model=RestaurantSearchResponse)
async def search_restaurants(request: RestaurantSearchRequest):
    """
    Search restaurants within radius using Firebase GeoPoint + geohash pattern.
    Fast and accurate with Haversine post-filtering.
    """
    try:
        firebase_service = get_firebase_service()
        
        # Search restaurants within radius
        restaurants_data = await firebase_service.search_restaurants(
            center_lat=request.center.latitude,
            center_lng=request.center.longitude,
            radius_km=request.radius_km
        )
        
        # Convert to Restaurant models
        restaurants = []
        for restaurant in restaurants_data:
            # Convert GeoPoint to dictionary format for Pydantic
            location_geopoint = restaurant["location"]
            location_dict = {
                "latitude": location_geopoint.latitude,
                "longitude": location_geopoint.longitude
            }
            
            restaurants.append(Restaurant(
                doc_id=restaurant["doc_id"],
                place_id=restaurant.get("place_id"),
                name=restaurant["name"],
                location=location_dict,  # Converted to dict
                distance_km=restaurant["distance_km"]
            ))
        
        return RestaurantSearchResponse(
            restaurants=restaurants,
            total_found=len(restaurants)
        )
        
    except Exception as e:
        print(f"Error in restaurant search: {e}")
        raise HTTPException(status_code=500, detail="Failed to search restaurants")


# Restaurant details endpoint
@app.post("/restaurant_details", response_model=RestaurantDetailsResponse)
async def get_restaurant_details(request: RestaurantDetailsRequest, background_tasks: BackgroundTasks):
    """
    Get comprehensive restaurant details from Firebase (if fresh) or Google Places API.
    Returns essential and pro-level restaurant information.
    """
    try:
        firebase_service = get_firebase_service()
        
        # First, try to get details from Firebase if they exist and are fresh
        details = await firebase_service.get_restaurant_details_from_firebase(request.place_id)
        
        if details:
            # Data exists in Firebase and is fresh, use it
            print(f"Using fresh data from Firebase for place_id: {request.place_id}")
            data_source = "firebase"
        else:
            # Data doesn't exist or is stale, fetch from Google Places API
            print(f"Fetching fresh data from Google Places API for place_id: {request.place_id}")
            details = await places_service.get_restaurant_details(request.place_id)
            data_source = "google_places"
        
        # Location is required and can be used for additional context
        print(f"Location provided: {request.location.latitude}, {request.location.longitude}")
        
        response = RestaurantDetailsResponse(
            # Basic Info (Place Details Essentials)
            name=details.get("name"),
            business_status=details.get("business_status"),
            rating=details.get("rating"),
            price_level=details.get("price_level"),
            
            # Location & Contact (Place Details Essentials)
            formatted_address=details.get("formatted_address"),
            phone_number=details.get("phone_number"),
            international_phone_number=details.get("international_phone_number"),
            
            # Categories & Types (Place Details Essentials)
            primary_type=details.get("primary_type"),
            types=details.get("types"),
            
            # Hours (Place Details Pro)
            regular_opening_hours=details.get("regular_opening_hours"),
            
            # Reviews & Content (Place Details Pro)
            editorial_summary=details.get("editorial_summary"),
            generative_summary=details.get("generative_summary"),
            review_summary=details.get("review_summary"),
            
            # Media (Place Details Pro)
            photos=details.get("photos"),
            
            # Maps Integration (Place Details Essentials)
            google_maps_uri=details.get("google_maps_uri"),
            website_uri=details.get("website_uri"),
            
            # Enterprise Level Fields
            user_rating_count=details.get("user_rating_count"),
            
            # Enterprise + Atmosphere Fields
            # Service Options
            takeout=details.get("takeout"),
            delivery=details.get("delivery"),
            dine_in=details.get("dine_in"),
            curbside_pickup=details.get("curbside_pickup"),
            reservable=details.get("reservable"),
            
            # Food & Beverage
            serves_breakfast=details.get("serves_breakfast"),
            serves_lunch=details.get("serves_lunch"),
            serves_dinner=details.get("serves_dinner"),
            serves_beer=details.get("serves_beer"),
            serves_wine=details.get("serves_wine"),
            serves_cocktails=details.get("serves_cocktails"),
            serves_vegetarian_food=details.get("serves_vegetarian_food"),
            
            # Ambience & Amenities
            outdoor_seating=details.get("outdoor_seating"),
            live_music=details.get("live_music"),
            good_for_groups=details.get("good_for_groups"),
            good_for_children=details.get("good_for_children"),
            good_for_watching_sports=details.get("good_for_watching_sports"),
            allows_dogs=details.get("allows_dogs"),
            restroom=details.get("restroom"),
            
            # Accessibility & Payment
            accessibility_options=details.get("accessibility_options"),
            payment_options=details.get("payment_options"),
            parking_options=details.get("parking_options")
        )
        
        # Add background task to update Firebase if we fetched fresh data from Google Places API
        if data_source == "google_places":
            background_tasks.add_task(update_restaurant_details_background, request.place_id)
            print(f"Added background task to update Firebase for place_id: {request.place_id}")
        else:
            print(f"No background task needed - using fresh Firebase data for place_id: {request.place_id}")
        
        return response
        
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        print(f"Error in restaurant_details endpoint: {e}")
        raise HTTPException(status_code=500, detail="Failed to get restaurant details")


# Multiple restaurant details endpoint with concurrent processing
@app.post("/multiple_restaurant_details", response_model=MultipleRestaurantDetailsResponse)
async def get_multiple_restaurant_details(request: MultipleRestaurantDetailsRequest, background_tasks: BackgroundTasks):
    """
    Get comprehensive restaurant details for multiple restaurants concurrently.
    Uses Firebase caching when available, otherwise fetches from Google Places API.
    Processes all requests concurrently for better performance.
    """
    try:
        import time
        start_time = time.time()
        firebase_service = get_firebase_service()
        
        # Process all place_ids concurrently
        print(f"🚀 Processing {len(request.place_ids)} restaurant details concurrently")
        
        # Create tasks for concurrent execution
        tasks = [
            get_single_restaurant_details(place_id, firebase_service) 
            for place_id in request.place_ids
        ]
        
        # Execute all tasks concurrently
        print(f"⏱️  Starting concurrent execution of {len(tasks)} tasks...")
        results = await asyncio.gather(*tasks, return_exceptions=True)
        
        total_elapsed = round((time.time() - start_time) * 1000, 1)
        print(f"✅ All {len(tasks)} tasks completed in {total_elapsed}ms (concurrent)")
        
        # Process results and build response
        restaurants = []
        errors = []
        place_ids_to_update = []  # For background tasks
        
        for result in results:
            if isinstance(result, Exception):
                # Handle exceptions from asyncio.gather
                print(f"Exception in concurrent processing: {str(result)}")
                errors.append({"place_id": "unknown", "error": str(result)})
                continue
                
            place_id, details, data_source = result
            
            if data_source.startswith("error:"):
                # Handle errors from our function
                error_msg = data_source.replace("error: ", "")
                errors.append({"place_id": place_id, "error": error_msg})
                continue
            
            # Create RestaurantDetailsItem from details
            restaurant_item = RestaurantDetailsItem(
                place_id=place_id,
                # Basic Info (Place Details Essentials)
                name=details.get("name"),
                business_status=details.get("business_status"),
                rating=details.get("rating"),
                price_level=details.get("price_level"),
                
                # Location & Contact (Place Details Essentials)
                formatted_address=details.get("formatted_address"),
                phone_number=details.get("phone_number"),
                international_phone_number=details.get("international_phone_number"),
                
                # Categories & Types (Place Details Essentials)
                primary_type=details.get("primary_type"),
                types=details.get("types"),
                
                # Hours (Place Details Pro)
                regular_opening_hours=details.get("regular_opening_hours"),
                
                # Reviews & Content (Place Details Pro)
                editorial_summary=details.get("editorial_summary"),
                generative_summary=details.get("generative_summary"),
                review_summary=details.get("review_summary"),
                
                # Media (Place Details Pro)
                photos=details.get("photos"),
                
                # Maps Integration (Place Details Essentials)
                google_maps_uri=details.get("google_maps_uri"),
                website_uri=details.get("website_uri"),
                
                # Enterprise Level Fields
                user_rating_count=details.get("user_rating_count"),
                
                # Enterprise + Atmosphere Fields
                # Service Options
                takeout=details.get("takeout"),
                delivery=details.get("delivery"),
                dine_in=details.get("dine_in"),
                curbside_pickup=details.get("curbside_pickup"),
                reservable=details.get("reservable"),
                
                # Food & Beverage
                serves_breakfast=details.get("serves_breakfast"),
                serves_lunch=details.get("serves_lunch"),
                serves_dinner=details.get("serves_dinner"),
                serves_beer=details.get("serves_beer"),
                serves_wine=details.get("serves_wine"),
                serves_cocktails=details.get("serves_cocktails"),
                serves_vegetarian_food=details.get("serves_vegetarian_food"),
                
                # Ambience & Amenities
                outdoor_seating=details.get("outdoor_seating"),
                live_music=details.get("live_music"),
                good_for_groups=details.get("good_for_groups"),
                good_for_children=details.get("good_for_children"),
                good_for_watching_sports=details.get("good_for_watching_sports"),
                allows_dogs=details.get("allows_dogs"),
                restroom=details.get("restroom"),
                
                # Accessibility & Payment
                accessibility_options=details.get("accessibility_options"),
                payment_options=details.get("payment_options"),
                parking_options=details.get("parking_options")
            )
            
            restaurants.append(restaurant_item)
            
            # Track place_ids that need background updates
            if data_source == "google_places":
                place_ids_to_update.append(place_id)
        
        # Add background tasks for place_ids that were fetched from Google Places API
        for place_id in place_ids_to_update:
            background_tasks.add_task(update_restaurant_details_background, place_id)
            print(f"Added background task to update Firebase for place_id: {place_id}")
        
        # Location is required and can be used for additional context
        print(f"Location provided: {request.location.latitude}, {request.location.longitude}")
        
        response = MultipleRestaurantDetailsResponse(
            restaurants=restaurants,
            total_found=len(restaurants),
            errors=errors if errors else None
        )
        
        print(f"Successfully processed {len(restaurants)} restaurants, {len(errors)} errors")
        return response
        
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        print(f"Error in multiple_restaurant_details endpoint: {e}")
        raise HTTPException(status_code=500, detail="Failed to get multiple restaurant details")


# Delete restaurant endpoint
@app.delete("/restaurant", response_model=DeleteRestaurantResponse)
async def delete_restaurant(request: DeleteRestaurantRequest):
    """
    Delete a restaurant from the database by place_id.
    
    This endpoint removes the restaurant document from Firebase.
    """
    try:
        firebase_service = get_firebase_service()
        
        # Delete the restaurant from Firebase
        success = await firebase_service.delete_restaurant_by_place_id(request.place_id)
        
        if success:
            return DeleteRestaurantResponse(
                success=True,
                message=f"Restaurant with place_id {request.place_id} successfully deleted",
                place_id=request.place_id
            )
        else:
            return DeleteRestaurantResponse(
                success=False,
                message=f"Restaurant with place_id {request.place_id} not found or could not be deleted",
                place_id=request.place_id
            )
        
    except Exception as e:
        print(f"Error in delete restaurant endpoint: {e}")
        raise HTTPException(status_code=500, detail="Failed to delete restaurant")

