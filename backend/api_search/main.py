from dotenv import load_dotenv
load_dotenv()  # take environment variables from .env.
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routers import health, agent_places

app = FastAPI(title="Agent Search API", version="1.1.0")

origins = [
    "http://localhost",
    "http://localhost:*",
    "http://localhost:8000",
    "http://127.0.0.1:8000",
    "https://preview.flutterflow.app",  # FF web preview host
    "https://palate-cve8jj.flutterflow.app",  # add prod domains when ready
    # "https://your-custom-domain.com",
]
# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,  # Configure this for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(health.router)
app.include_router(agent_places.router)
