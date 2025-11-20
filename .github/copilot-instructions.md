## Quick orientation

This repo provides a small FastAPI backend (under `backend/`) plus data scripts and tests for working with Google Places and Firestore-backed restaurant data.

Key areas to read first:
- `backend/app/main.py` — FastAPI app and routers (includes `agent_places` and `health`).
- `backend/agents/` — LangChain-based agent code and tools (example: `places_pruner.py`, `tools_google.py`, `tools_db.py`).
- `backend/services/` — low-level integrations: `google_places.py` (text_search), `firestore.py` (db access).
- `backend/data/` and `data/` — CSVs and scripts for dataset extraction and uploads.

## Big-picture architecture

- FastAPI backend exposes endpoints defined in `backend/app/routers/` and wires agent logic from `backend/agents/`.
- Agents orchestrate two layers: external API calls (Google Places) and local DB checks (Firestore). See `places_pruner.py` for a concrete example: it asks the LLM to call `places_text_search` then `db_filter_known_place_ids` and return a strict JSON schema.
- Services in `backend/services/` are tiny wrappers around external SDKs: `google_places.py` (HTTPX calls to Google Places) and `firestore.py` (google-cloud-firestore client). The Firestore helper batches `place_id` queries in chunks of 10.

## Environment & credentials

- GOOGLE_PLACES_API_KEY — required by `backend/services/google_places.py`.
- GCP_PROJECT and GOOGLE_APPLICATION_CREDENTIALS — required for Firestore access. A service account JSON exists in the repo at `backend/palate-cve8jj-firebase-adminsdk-fbsvc-a68084b529.json`; set `GOOGLE_APPLICATION_CREDENTIALS` to that path for local testing.
- Many modules call `load_dotenv()` so a `.env` file in `backend/` or the current working directory is frequently used during development.

## How to run locally (recommended)

1. Create a virtualenv and install deps (project uses multiple subfolders with their own requirements; check `backend/tests/testing_placesapi/requirements.txt` for the Places test dependencies):

   - install using your usual workflow (pip/poetry). There is no single top-level `requirements.txt` in the repo.

2. Start the API (from repo root):

   - uvicorn backend.app.main:app --reload --port 8000

3. Run the Places portrait test (see `backend/tests/testing_placesapi/README.md`):

   - cd backend/tests/testing_placesapi
   - pip install -r requirements.txt
   - create a `.env` with `GOOGLE_PLACES_API_KEY` and run `python main.py`

## Agent & LLM conventions (important)

- Agents live in `backend/agents/` and use LangChain helpers. Tools must be small, single-responsibility functions exposing a stable signature. Example tools used in `places_pruner.py`: `places_text_search_tool` and `db_filter_known_place_ids`.
- Agents instruct the LLM to return a strict machine-parsable response (often raw JSON). Example: `places_pruner.py`'s SYSTEM prompt mandates a JSON object with `kept`, `dropped`, `total_candidates`. Code defensively: the agent runner already tries to json.loads string outputs.
- Tool outputs should be JSON-serializable to make downstream parsing reliable.

## Data & DB patterns

- Firestore collection `restaurants` stores docs with fields `name`, `address`, `place_id`. See `backend/services/firestore.py` and its `restaurant_by_place_ids` helper — note the `in` query chunking of 10.
- CSV datasets live in `data/data/processed` and `data/data/raw` (e.g., `restaurant_data_filtered.csv`). Data scripts are in `backend/data/scripts/`.

## Debugging tips

- If tests or agents fail to access Firestore, verify `GOOGLE_APPLICATION_CREDENTIALS` and `GCP_PROJECT`.
- For LangChain agent debugging, enable verbose in `AgentExecutor` or log the raw `result` before parsing in `places_pruner.AgentRunner.run`.
- Network calls use `httpx.AsyncClient` (see `google_places.py`) — inspect timeouts and API key usage if requests fail.

## Examples to copy/paste

- Build and run the places pruner agent in a REPL for quick checks:

  - from `backend.agents.places_pruner` import `build_places_pruner_agent`
  - instantiate and call `.run()` with a small payload object that has attributes: `google_place_id`, `query`, `address`, `lat`, `lng`, `radius_m` (see `places_pruner.py` for expected behavior).

## Where to look next

- Agent orchestration: `backend/agents/*.py`
- Low-level APIs: `backend/services/google_places.py`, `backend/services/firestore.py`
- Tests & experiments: `backend/tests/testing_placesapi/` (portrait photo testing)

If any section is unclear or you'd like this file to include runnable setup commands tailored to your environment (pip/poetry), tell me which package manager you use and I will update it.
