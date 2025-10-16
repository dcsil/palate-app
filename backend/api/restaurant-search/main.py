"""
FastAPI application for restaurant search with Google Places API and Firebase integration
"""
from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
from typing import List
from models import PlaceSearchResult, HealthResponse, RootResponse, LatLng, NearbyRestaurantsResponse, NearbyRestaurant, RestaurantSearchResponse, RestaurantSearchResult, RestaurantDetailsRequest
from places_service import places_service
from firebase_service import get_firebase_service

load_dotenv()

app = FastAPI(title="Restaurant Search API", version="1.0.0")

# CORS middleware configuration
origins = [
    "http://localhost:*",
    "http://localhost:8000",      # FastAPI docs and local development
    "https://preview.flutterflow.app",  # FF web preview host
    "https://palate-cve8jj.flutterflow.app",  # add prod domains when ready
    # "https://your-custom-domain.com",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,          # or ["*"] for quick testing (see note below)
    allow_credentials=True,         # set False if you want to keep "*" in allow_origins
    allow_methods=["*"],            # or list: ["GET","POST","OPTIONS"]
    allow_headers=["*"],            # or list: ["Authorization","Content-Type",...]
    expose_headers=["*"],           # optional, if you read custom headers on client
)

# Lazy, module-level handle (set on startup)
_FIREBASE = None

@app.on_event("startup")
def startup():
    global _FIREBASE
    # Initialize Firebase via ADC (Cloud Run) or local gcloud ADC mount
    _FIREBASE = get_firebase_service()

@app.get("/", response_model=RootResponse)
async def root():
    return RootResponse(message="Restaurant Search API is running")

@app.get("/health", response_model=HealthResponse)
async def health():
    return HealthResponse(status="ok")

@app.get("/test-firebase")
async def test_firebase():
    """Test Firebase connectivity and restaurant collection access"""
    try:
        # Test basic Firebase connection
        restaurants_ref = _FIREBASE.db.collection("restaurants")
        docs = restaurants_ref.limit(1).get()
        
        return {
            "status": "success",
            "firebase_connected": True,
            "restaurants_collection_accessible": True,
            "sample_docs_count": len(docs)
        }
    except Exception as e:
        return {
            "status": "error",
            "firebase_connected": False,
            "error": str(e)
        }

@app.get("/place/{place_id}", response_model=PlaceSearchResult)
async def get_place(
    place_id: str,
    lat: float = Query(..., description="User latitude"),
    lng: float = Query(..., description="User longitude"),
    min_photo_height: int = Query(400, ge=1, le=4800),
    max_photos: int = Query(8, ge=1, le=20),
):
    """
    Get comprehensive place details from Google Places API and update Firebase.
    """
    try:
        # 1) Fetch from Google Places API
        search_result = await places_service.get_place_details(
            place_id=place_id,
            user_lat=lat,
            user_lng=lng,
            min_photo_height=min_photo_height,
            max_photos=max_photos,
        )

        # 2) Update Firestore (safe even if not found)
        try:
            firebase_updated = await _FIREBASE.update_restaurant_search_result(place_id, search_result)
            search_result["firebase_updated"] = firebase_updated
            if not firebase_updated:
                search_result["firebase_message"] = "Restaurant not found in database"
        except Exception as fb_err:
            search_result["firebase_updated"] = False
            search_result["firebase_error"] = str(fb_err)

        return PlaceSearchResult(**search_result)

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching place details: {str(e)}")


@app.post("/nearby-restaurants", response_model=NearbyRestaurantsResponse)
async def get_nearby_restaurants(
    location: LatLng,
    limit: int = Query(20, ge=1, le=50, description="Maximum number of restaurants to return")
):
    """
    Get nearby restaurants and update them with place details in parallel.
    """
    try:
        print(f"Starting nearby-restaurants request: lat={location.lat}, lng={location.lng}, limit={limit}")
        # 1) Get nearby restaurants from Firestore
        print("Fetching nearby restaurants from Firestore...")
        nearby_restaurants = await _FIREBASE.get_nearby_restaurants(
            user_lat=location.lat,
            user_lng=location.lng,
            limit=limit
        )
        print(f"Found {len(nearby_restaurants)} nearby restaurants")
        
        if not nearby_restaurants:
            return NearbyRestaurantsResponse(
                restaurants=[],
                total_found=0,
                updated_count=0
            )
        
        # 2) Identify restaurants that need updating (no search_timestamp)
        restaurants_to_update = [
            r for r in nearby_restaurants 
            if not r["has_search_timestamp"] and r["place_id"]
        ]
        print(f"Restaurants to update: {len(restaurants_to_update)}")
        
        # 3) Update restaurants in parallel
        import asyncio
        from httpx import AsyncClient
        
        async def update_restaurant(restaurant_data):
            """Update a single restaurant with place details"""
            try:
                # Call the existing place endpoint internally
                search_result = await places_service.get_place_details(
                    place_id=restaurant_data["place_id"],
                    user_lat=location.lat,
                    user_lng=location.lng,
                    min_photo_height=400,
                    max_photos=8
                )
                
                # Update Firebase
                firebase_updated = await _FIREBASE.update_restaurant_search_result(
                    restaurant_data["place_id"], 
                    search_result
                )
                
                return {
                    "restaurant_data": restaurant_data,
                    "search_result": search_result,
                    "firebase_updated": firebase_updated,
                    "error": None
                }
            except Exception as e:
                return {
                    "restaurant_data": restaurant_data,
                    "search_result": None,
                    "firebase_updated": False,
                    "error": str(e)
                }
        
        # Execute updates in parallel
        print("Starting parallel updates...")
        update_tasks = [update_restaurant(r) for r in restaurants_to_update]
        update_results = await asyncio.gather(*update_tasks, return_exceptions=True)
        print(f"Completed {len(update_results)} parallel updates")
        
        # 4) Build response
        response_restaurants = []
        updated_count = 0
        
        for restaurant_data in nearby_restaurants:
            # Find update result for this restaurant
            update_result = None
            for result in update_results:
                if (isinstance(result, dict) and 
                    result.get("restaurant_data", {}).get("place_id") == restaurant_data["place_id"]):
                    update_result = result
                    break
            
            # Build restaurant response
            search_result = None
            error = None
            
            if update_result:
                if update_result["search_result"]:
                    search_result = PlaceSearchResult(**update_result["search_result"])
                error = update_result["error"]
            
            restaurant_response = NearbyRestaurant(
                doc_id=restaurant_data["doc_id"],
                place_id=restaurant_data["place_id"],
                name=restaurant_data["name"],
                distance_meters=restaurant_data["distance_meters"],
                location=LatLng(lat=restaurant_data["latitude"], lng=restaurant_data["longitude"]),
                has_search_timestamp=restaurant_data["has_search_timestamp"],
                search_result=search_result,
                error=error
            )
            
            response_restaurants.append(restaurant_response)
            
            if update_result and update_result["firebase_updated"]:
                updated_count += 1
        
        print(f"Returning response: {len(response_restaurants)} restaurants, {updated_count} updated")
        return NearbyRestaurantsResponse(
            restaurants=response_restaurants,
            total_found=len(nearby_restaurants),
            updated_count=updated_count
        )
        
    except Exception as e:
        print(f"Error in nearby-restaurants endpoint: {str(e)}")
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=f"Error fetching nearby restaurants: {str(e)}")


@app.post("/nearby-restaurants-places", response_model=NearbyRestaurantsResponse)
async def get_nearby_restaurants_places(
    location: LatLng,
    limit: int = Query(20, ge=1, le=50, description="Maximum number of restaurants to return"),
    radius_meters: int = Query(5000, ge=100, le=50000, description="Search radius in meters"),
    page: int = Query(1, ge=1, description="Page number for pagination (increases radius)"),
    radius_multiplier: float = Query(1.5, ge=1.0, le=5.0, description="Radius multiplier for each page")
):
    """
    Get nearby restaurants using Google Places API and filter by those in our database.
    This approach uses Places API to find restaurants and then filters to only include
    restaurants that exist in our Firebase database.
    
    Pagination works by increasing the search radius for each page:
    - Page 1: radius_meters
    - Page 2: radius_meters * radius_multiplier  
    - Page 3: radius_meters * radius_multiplier^2
    - etc.
    """
    try:
        # Calculate effective radius based on page number
        effective_radius = int(radius_meters * (radius_multiplier ** (page - 1)))
        effective_radius = min(effective_radius, 50000)  # Google's max is 50km
        
        print(f"Starting nearby-restaurants-places request: lat={location.lat}, lng={location.lng}, limit={limit}, page={page}, effective_radius={effective_radius}")
        
        # 1) Search for nearby restaurants using Google Places API
        print("Searching for nearby restaurants using Google Places API...")
        
        # Use multiple search centers for better coverage
        search_centers = [
            (location.lat, location.lng),  # Original center
            (location.lat + 0.01, location.lng),  # North
            (location.lat - 0.01, location.lng),  # South
            (location.lat, location.lng + 0.01),  # East
            (location.lat, location.lng - 0.01),  # West
        ]
        
        all_places_results = []
        seen_place_ids = set()
        
        for center_lat, center_lng in search_centers:
            try:
                places_results = await places_service.search_nearby_restaurants(
                    user_lat=center_lat,
                    user_lng=center_lng,
                    radius_meters=effective_radius,
                    limit=20  # Always get max from each center
                )
                
                # Add unique results
                for result in places_results:
                    place_id = result.get("place_id")
                    if place_id and place_id not in seen_place_ids:
                        all_places_results.append(result)
                        seen_place_ids.add(place_id)
                        
            except Exception as e:
                print(f"Error searching from center ({center_lat}, {center_lng}): {str(e)}")
                continue
        
        places_results = all_places_results
        print(f"Found {len(places_results)} restaurants from Places API")
        
        if not places_results:
            return NearbyRestaurantsResponse(
                restaurants=[],
                total_found=0,
                updated_count=0
            )
        
        # 2) Extract place_ids and check which ones exist in our database
        place_ids = [result["place_id"] for result in places_results if result.get("place_id")]
        print(f"Looking up {len(place_ids)} place_ids in Firebase...")
        
        db_restaurants = await _FIREBASE.get_restaurants_by_place_ids(place_ids)
        print(f"Found {len(db_restaurants)} restaurants in our database")
        
        # 3) Filter Places API results to only include restaurants in our database and update Firebase
        filtered_results = []
        updated_count = 0
        
        for places_result in places_results:
            place_id = places_result.get("place_id")
            if place_id and place_id in db_restaurants:
                db_restaurant = db_restaurants[place_id]
                
                # Update Firebase with fresh Places API data
                try:
                    firebase_updated = await _FIREBASE.update_restaurant_search_result(place_id, places_result)
                    if firebase_updated:
                        updated_count += 1
                        print(f"Updated Firebase for restaurant {place_id}")
                except Exception as fb_err:
                    print(f"Error updating Firebase for {place_id}: {str(fb_err)}")
                
                # Create NearbyRestaurant response
                restaurant_response = NearbyRestaurant(
                    doc_id=db_restaurant["doc_id"],
                    place_id=place_id,
                    name=db_restaurant["name"],
                    distance_meters=places_result.get("distance_meters", 0),
                    location=LatLng(lat=db_restaurant["latitude"], lng=db_restaurant["longitude"]),
                    has_search_timestamp=True,  # Now has search timestamp after update
                    search_result=PlaceSearchResult(**places_result),
                    error=None
                )
                filtered_results.append(restaurant_response)
        
        print(f"Returning {len(filtered_results)} restaurants that exist in our database, {updated_count} updated in Firebase")
        return NearbyRestaurantsResponse(
            restaurants=filtered_results,
            total_found=len(filtered_results),
            updated_count=updated_count
        )
        
    except Exception as e:
        print(f"Error in nearby-restaurants-places endpoint: {str(e)}")
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=f"Error fetching nearby restaurants: {str(e)}")


@app.post("/search-nearby-restaurants", response_model=RestaurantSearchResponse)
async def search_nearby_restaurants(
    location: LatLng,
    radius_meters: int = Query(5000, ge=100, le=50000, description="Search radius in meters")
):
    """
    Search for nearby restaurants within a radius. Returns ALL restaurants in your database
    within the specified radius, sorted by distance. This is for frontend pagination.
    
    The frontend should store the returned place_ids and use them with the 
    /get-restaurant-details endpoint for detailed data.
    """
    try:
        print(f"Searching nearby restaurants: lat={location.lat}, lng={location.lng}, radius={radius_meters}")
        
        # Get all restaurants within radius from Firebase
        restaurants = await places_service.search_nearby_restaurants(
            user_lat=location.lat,
            user_lng=location.lng,
            radius_meters=radius_meters
        )
        
        # Convert to response model
        restaurant_results = []
        for restaurant in restaurants:
            restaurant_results.append(RestaurantSearchResult(
                place_id=restaurant["place_id"],
                name=restaurant["name"],
                latitude=restaurant["latitude"],
                longitude=restaurant["longitude"],
                distance_meters=restaurant["distance_meters"],
                doc_id=restaurant["doc_id"],
                has_search_timestamp=restaurant["has_search_timestamp"]
            ))
        
        print(f"Found {len(restaurant_results)} restaurants within {radius_meters}m radius")
        return RestaurantSearchResponse(
            restaurants=restaurant_results,
            total_found=len(restaurant_results)
        )
        
    except Exception as e:
        print(f"Error in search-nearby-restaurants endpoint: {str(e)}")
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=f"Error searching nearby restaurants: {str(e)}")


@app.post("/get-restaurant-details", response_model=List[PlaceSearchResult])
async def get_restaurant_details(request: RestaurantDetailsRequest):
    """
    Get detailed restaurant data for place_ids.
    1. Check Firebase first for cached data (has search_timestamp)
    2. Call Google Places API for missing restaurants
    3. Save results to Firebase
    4. Return all results to user
    """
    try:
        print(f"Getting restaurant details for {len(request.place_ids)} place_ids: {request.place_ids}")
        
        # Step 1: Check Firebase for existing restaurants
        print("Step 1: Checking Firebase for existing restaurants...")
        existing_restaurants = await _FIREBASE.get_restaurants_by_place_ids(request.place_ids)
        print(f"Found {len(existing_restaurants)} existing restaurants in Firebase")
        
        # Step 2: Separate cached vs non-cached restaurants
        cached_results = []
        restaurants_to_fetch = []
        
        for place_id in request.place_ids:
            if place_id in existing_restaurants:
                restaurant = existing_restaurants[place_id]
                if restaurant.get("has_search_timestamp"):
                    print(f"Using cached data for {place_id}")
                    # Convert Firebase data to PlaceSearchResult format
                    cached_result = _convert_firebase_to_place_search_result(restaurant, place_id)
                    cached_results.append(cached_result)
                else:
                    print(f"Restaurant {place_id} exists but needs fresh data")
                    restaurants_to_fetch.append(place_id)
            else:
                print(f"Restaurant {place_id} not found in Firebase")
                restaurants_to_fetch.append(place_id)
        
        # Step 3: Fetch fresh data from Google Places API
        fresh_results = []
        if restaurants_to_fetch:
            print(f"Step 2: Fetching fresh data for {len(restaurants_to_fetch)} restaurants from Google Places API")
            fresh_data = await places_service.get_restaurants_details(
                place_ids=restaurants_to_fetch,
                user_lat=request.user_lat,
                user_lng=request.user_lng,
                min_photo_height=400,
                max_photos=4
            )
            
            # Step 4: Save fresh data to Firebase and convert to response format
            for result in fresh_data:
                if result and "error" not in result:
                    # Save to Firebase
                    try:
                        firebase_updated = await _FIREBASE.update_restaurant_search_result(result['place_id'], result)
                        if firebase_updated:
                            result["firebase_updated"] = True
                            result["firebase_message"] = "Successfully saved to Firebase"
                            print(f"Saved {result['place_id']} to Firebase")
                        else:
                            result["firebase_updated"] = False
                            result["firebase_message"] = "Failed to save to Firebase"
                            print(f"Failed to save {result['place_id']} to Firebase")
                    except Exception as e:
                        result["firebase_updated"] = False
                        result["firebase_error"] = str(e)
                        print(f"Error saving {result['place_id']} to Firebase: {str(e)}")
                    
                    # Convert to response format
                    fresh_result = PlaceSearchResult(**result)
                    fresh_results.append(fresh_result)
                elif result and "error" in result:
                    print(f"Error fetching {result['place_id']}: {result['error']}")
                    # Delete from Firebase if it exists
                    try:
                        await _FIREBASE.delete_restaurant_by_place_id(result['place_id'])
                    except:
                        pass
        
        # Step 5: Combine and return results
        all_results = cached_results + fresh_results
        print(f"Returning {len(all_results)} total results ({len(cached_results)} cached, {len(fresh_results)} fresh)")
        return all_results
        
    except Exception as e:
        print(f"Error in get-restaurant-details endpoint: {str(e)}")
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=f"Error getting restaurant details: {str(e)}")


def _convert_firebase_to_place_search_result(restaurant_data: dict, place_id: str) -> PlaceSearchResult:
    """Convert Firebase restaurant data to PlaceSearchResult format"""
    return PlaceSearchResult(
        place_id=place_id,
        name=restaurant_data.get("name", "Unknown Restaurant"),
        distance_meters=0,  # Will be calculated by frontend
        firebase_updated=False,
        firebase_message="Using cached data",
        
        # Required fields with defaults
        photos=restaurant_data.get("images", []),
        hours=restaurant_data.get("current_hours", {}),
        service_options={
            "takeout": restaurant_data.get("takeout"),
            "delivery": restaurant_data.get("delivery"),
            "dine_in": restaurant_data.get("dine_in"),
            "curbside_pickup": restaurant_data.get("curbside_pickup"),
            "reservable": restaurant_data.get("reservable"),
            "serves": {
                "breakfast": restaurant_data.get("serves_breakfast"),
                "lunch": restaurant_data.get("serves_lunch"),
                "dinner": restaurant_data.get("serves_dinner"),
                "beer": restaurant_data.get("serves_beer"),
                "wine": restaurant_data.get("serves_wine"),
                "cocktails": restaurant_data.get("serves_cocktails"),
                "vegetarian_food": restaurant_data.get("serves_vegetarian")
            }
        },
        ambience={
            "outdoor_seating": restaurant_data.get("outdoor_seating"),
            "live_music": restaurant_data.get("live_music"),
            "good_for_groups": restaurant_data.get("good_for_groups"),
            "good_for_children": restaurant_data.get("good_for_children"),
            "good_for_watching_sports": restaurant_data.get("good_for_watching_sports"),
            "allows_dogs": restaurant_data.get("allows_dogs"),
            "restroom": restaurant_data.get("has_restroom")
        },
        accessibility_options=restaurant_data.get("accessibility_options"),
        payment_options=restaurant_data.get("payment_options"),
        parking_options=restaurant_data.get("parking_options"),
        editorial_summary=restaurant_data.get("editorial_summary"),
        generative_summary={
            "overview": restaurant_data.get("generative_overview"),
            "description": restaurant_data.get("generative_description")
        },
        review_summary=restaurant_data.get("review_summary"),
        rating=restaurant_data.get("rating"),
        user_rating_count=restaurant_data.get("user_rating_count"),
        price_level=restaurant_data.get("price_level"),
        primary_type=restaurant_data.get("primary_type"),
        types=restaurant_data.get("types", []),
        maps_links=restaurant_data.get("maps_links")
    )
