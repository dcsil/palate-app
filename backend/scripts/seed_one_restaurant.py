# backend/scripts/seed_one_restaurant.py
# DELETE SUSHI KAJI LATER

import os
from dotenv import load_dotenv
load_dotenv()
from google.cloud import firestore

project = os.getenv("GCP_PROJECT")
db = firestore.Client(project=project)

doc = {
  "name": "Sushi Kaji",
  "address": "860 The Queensway, Etobicoke, ON",
  "place_id": "ChIJq3ym0PcxK4gR8oXnBZ3m7lE",  # example; replace with a real one if you like
  "city": "Toronto",
  "cuisine": ["Japanese"],
}
db.collection("restaurants").add(doc)
print("Seeded 1 restaurant.")
