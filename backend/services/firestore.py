import os
from dotenv import load_dotenv
from google.cloud import firestore

# FOR LOCAL: set GOOGLE_APPLICATION_CREDENTIALS to the path of your service account json file

load_dotenv()  # take environment variables from .env.
GCP_PROJECT = os.environ.get("GCP_PROJECT")
_db = None

def db():
    global _db
    if _db is None:
        _db = firestore.Client(project=GCP_PROJECT)
    return _db

def restaurant_by_place_ids(place_ids: list[str]) -> set[str]:
    """
    Firetore: collection "restaurants", docId arbitrary, fields: name, address, place_id
    Query by place_id in cunks of 10 (Firestore 'in' clause limit)
    """
    found = set()
    for chunk in [place_ids[i:i + 10] for i in range(0, len(place_ids), 10)]:
        q = db().collection("restaurants").where("place_id", "in", chunk).stream()
        for doc in q:
            found.add(doc.to_dict()["place_id"])
    return found
