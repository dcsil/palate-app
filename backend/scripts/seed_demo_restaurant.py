# backend/scripts/seed_demo_restaurant.py
import os
from dotenv import load_dotenv
load_dotenv()
from google.cloud import firestore

project = os.getenv("GCP_PROJECT")
db = firestore.Client(project=project)

doc = {
  "name": "Sushi Kaji",
  "address": "860 The Queensway, Etobicoke, ON",
  "place_id": "DEMO_PID_1",   # must match the stub above
  "city": "Toronto",
  "cuisine": ["Japanese"]
}
db.collection("restaurants").add(doc)
print("Seeded demo restaurant with place_id=DEMO_PID_1")
