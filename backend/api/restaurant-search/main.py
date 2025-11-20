"""
FastAPI application for restaurant search with Google Places API and Firebase integration
"""
from fastapi import FastAPI, HTTPException, Query
from dotenv import load_dotenv
from models import PlaceSearchResult, HealthResponse, RootResponse, LatLng, NearbyRestaurantsResponse, NearbyRestaurant
from places_service import places_service
from firebase_service import get_firebase_service

load_dotenv()

app = FastAPI(title="Restaurant Search API", version="1.0.0")

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
