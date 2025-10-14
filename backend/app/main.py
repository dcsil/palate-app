from dotenv import load_dotenv
load_dotenv()  # take environment variables from .env.
from fastapi import FastAPI
from app.routers import health, agent_places

app = FastAPI(title="Vera Backend API", version="1.0.0")
app.include_router(health.router)
app.include_router(agent_places.router)
