# Deployment Guide

Complete guide for running locally and deploying to Google Cloud Platform.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Local Development](#local-development)
- [Docker Setup](#docker-setup)
- [Google Cloud Deployment](#google-cloud-deployment)
  - [CI/CD Setup](#cicd-setup)
- [Environment Variables](#environment-variables)
- [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Software
- **Python 3.11+** - [Download](https://www.python.org/downloads/)
- **Node.js 18+** - [Download](https://nodejs.org/) (for Flutter web)
- **Flutter SDK 3.0+** - [Download](https://flutter.dev/docs/get-started/install)
- **Docker Desktop** - [Download](https://www.docker.com/products/docker-desktop)
- **Google Cloud SDK** - [Download](https://cloud.google.com/sdk/docs/install)
- **Git** - [Download](https://git-scm.com/downloads)

### Accounts & Setup
1. **GCP Project** - Create at [console.cloud.google.com](https://console.cloud.google.com), enable billing
2. **Firebase Project** - Create at [console.firebase.google.com](https://console.firebase.google.com), link to GCP, enable Firestore
3. **API Keys** - Google Places API, Google Maps API, OpenAI API
4. **Service Account** - Create in GCP Console, download JSON key, grant roles: `Cloud Datastore User`, `Firebase Admin SDK Administrator Service Agent`

**Initial gcloud setup:**
```bash
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
```

---

## Local Development

### Frontend (Flutter)

```bash
cd frontend/palate
flutter pub get
flutter doctor  # Verify setup
```

**Run:**
- Web: `flutter run -d chrome`
- Android: `flutter run -d android`
- iOS: `flutter run -d ios` (macOS only)

**Config files:** `lib/backend/`, `firebase/`, `android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist`

---

### Backend: API Search Service

**Location:** `backend/api_search`

**Setup:**
```bash
python -m venv .venv
# Windows: .venv\Scripts\activate
# macOS/Linux: source .venv/bin/activate
pip install -r requirements.txt
```

**Environment (`.env` file):**
```env
GCP_PROJECT=your-gcp-project-id
GOOGLE_APPLICATION_CREDENTIALS=./firebase-service.json
GOOGLE_PLACES_API_KEY=your-key
OPENAI_API_KEY=your-key
DEMO_MODE=false
```

**Firebase:** Download service account JSON → save as `firebase-service.json` in `backend/api_search/`

**Run:**
```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

**Endpoints:**
- `GET /health` - Health check
- `POST /agent/search` - Search restaurants
- `POST /agent/rank` - Rank restaurants by archetype

**URLs:** `http://127.0.0.1:8000` | Docs: `/docs` | Health: `/health`

---

### Backend: Restaurant Search API

**Location:** `backend/api/restaurant-search`

**Setup:**
```bash
python -m venv venv
# Windows: venv\Scripts\activate
# macOS/Linux: source venv/bin/activate
pip install -r requirements.txt
```

**Environment (`.env` file):**
```env
GOOGLE_MAPS_API_KEY=your-key
GOOGLE_CLOUD_PROJECT=your-project-id
FIREBASE_SERVICE_ACCOUNT_JSON={"type":"service_account",...}  # Optional for local
ENVIRONMENT=development
```

**Run:**
```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8001
```

**Endpoints:**
- `GET /health`, `GET /ready` - Health checks
- `POST /location` - Get location from coordinates
- `POST /restaurants/search` - Search in radius
- `POST /restaurant_details` - Single restaurant details
- `POST /multiple_restaurant_details` - Multiple restaurants
- `DELETE /restaurant` - Delete restaurant

**URLs:** `http://127.0.0.1:8001` | Docs: `/docs` | Health: `/health`

---

## Docker Setup

### Build Images

**API Search Service:**
```bash
cd backend/api_search
docker build -t agent-search-api:latest .
```

**Restaurant Search API:**
```bash
cd backend/api/restaurant-search
docker build -t restaurant-search-api:latest .
```

### Run Locally

**API Search Service:**
```bash
docker run -d --name agent-search-api -p 8000:8080 \
  -e GCP_PROJECT=your-project-id \
  -e GOOGLE_PLACES_API_KEY=your-key \
  -e OPENAI_API_KEY=your-key \
  -e GOOGLE_APPLICATION_CREDENTIALS=/app/firebase-service.json \
  -v /path/to/firebase-service.json:/app/firebase-service.json:ro \
  agent-search-api:latest
```

**Restaurant Search API:**
```bash
docker run -d --name restaurant-search-api -p 8001:8080 \
  -e GOOGLE_MAPS_API_KEY=your-key \
  -e GOOGLE_CLOUD_PROJECT=your-project-id \
  -e FIREBASE_SERVICE_ACCOUNT_JSON='{"type":"service_account",...}' \
  restaurant-search-api:latest
```

**Manage containers:**
```bash
docker ps                    # List running
docker logs <container-name> # View logs
docker stop <container-name> # Stop
docker rm <container-name>   # Remove
```

---

## Google Cloud Deployment

### Initial Setup

```bash
gcloud auth login
gcloud auth application-default login
gcloud config set project YOUR_PROJECT_ID

# Enable APIs
gcloud services enable \
  run.googleapis.com \
  cloudbuild.googleapis.com \
  artifactregistry.googleapis.com \
  firestore.googleapis.com
```

### Artifact Registry

```bash
# Create repository
gcloud artifacts repositories create palate-repos \
  --repository-format=docker \
  --location=us-central1 \
  --description="Docker repository for Palate application"

# Configure Docker auth
gcloud auth configure-docker us-central1-docker.pkg.dev
```

### CI/CD Setup

The project uses **Google Cloud Build** for automated CI/CD pipelines. Each service has a `cloudbuild.yaml` that defines the build, test, and deployment process.

#### Pipeline Workflow

Each `cloudbuild.yaml` configures a pipeline that:
1. **Tests** - Runs pytest test suite (fails build if tests fail)
2. **Builds** - Creates Docker image from Dockerfile
3. **Pushes** - Uploads image to Container Registry/Artifact Registry
4. **Deploys** - Automatically deploys to Cloud Run

#### Setting Up Automatic Triggers

**Option 1: GitHub/GitLab Integration (Recommended)**

1. **Connect Repository:**
   ```bash
   # Via Console: Cloud Build → Triggers → Connect Repository
   # Or via CLI:
   gcloud builds triggers create github \
     --name="api-search-cicd" \
     --repo-name="YOUR_REPO" \
     --repo-owner="YOUR_GITHUB_USERNAME" \
     --branch-pattern="^main$" \
     --build-config="backend/api_search/cloudbuild.yaml"
   ```

2. **Configure Triggers:**
   - Go to [Cloud Build Triggers](https://console.cloud.google.com/cloud-build/triggers)
   - Click "Create Trigger"
   - Connect your GitHub/GitLab repository
   - Set trigger conditions (branch, path, etc.)
   - Point to `cloudbuild.yaml` file location

**Option 2: Manual Trigger**

```bash
# API Search Service
cd backend/api_search
gcloud builds submit --config cloudbuild.yaml

# Restaurant Search API
cd backend/api/restaurant-search
gcloud builds submit --config cloudbuild.yaml
```

#### CI/CD Configuration Files

**`backend/api_search/cloudbuild.yaml`:**
- Runs tests from `tests/` directory
- Builds Docker image tagged with `BUILD_ID` and `latest`
- Pushes to Container Registry (`gcr.io`)
- Deploys to Cloud Run service `agent-search-api`

**`backend/api/restaurant-search/cloudbuild.yaml`:**
- Runs tests from `tests/` directory
- Builds Docker image tagged with `COMMIT_SHA`
- Pushes to Container Registry (`gcr.io`)
- Deploys to Cloud Run service `restaurant-search-api`

#### Trigger Conditions

Configure triggers to run on:
- **Push to main branch** - Automatic production deployments
- **Pull requests** - Run tests only (optional)
- **Specific paths** - Only trigger when relevant files change
- **Tags** - Deploy specific versions

**Example trigger setup:**
```bash
# Trigger on push to main for api_search
gcloud builds triggers create github \
  --name="api-search-deploy" \
  --repo-name="YOUR_REPO" \
  --branch-pattern="^main$" \
  --included-files="backend/api_search/**" \
  --build-config="backend/api_search/cloudbuild.yaml"

# Trigger on push to main for restaurant-search
gcloud builds triggers create github \
  --name="restaurant-search-deploy" \
  --repo-name="YOUR_REPO" \
  --branch-pattern="^main$" \
  --included-files="backend/api/restaurant-search/**" \
  --build-config="backend/api/restaurant-search/cloudbuild.yaml"
```

#### Viewing Build History

```bash
# List recent builds
gcloud builds list

# View specific build logs
gcloud builds log BUILD_ID

# View in Console
# https://console.cloud.google.com/cloud-build/builds
```

### Deploy to Cloud Run

#### Method 1: CI/CD Pipeline (Recommended)

**Automatic (via Git trigger):**
- Push to configured branch → Pipeline runs automatically

**Manual trigger:**
```bash
# API Search Service
cd backend/api_search
gcloud builds submit --config cloudbuild.yaml

# Restaurant Search API
cd backend/api/restaurant-search
gcloud builds submit --config cloudbuild.yaml
```

#### Method 2: Manual Deployment

**Build & Push:**
```bash
# API Search Service
cd backend/api_search
docker build -t us-central1-docker.pkg.dev/YOUR_PROJECT_ID/palate-repos/agent-search-api:latest .
docker push us-central1-docker.pkg.dev/YOUR_PROJECT_ID/palate-repos/agent-search-api:latest

# Restaurant Search API
cd ../api/restaurant-search
docker build -t us-central1-docker.pkg.dev/YOUR_PROJECT_ID/palate-repos/restaurant-search-api:latest .
docker push us-central1-docker.pkg.dev/YOUR_PROJECT_ID/palate-repos/restaurant-search-api:latest
```

**Deploy:**
```bash
# API Search Service
gcloud run deploy agent-search-api \
  --image us-central1-docker.pkg.dev/YOUR_PROJECT_ID/palate-repos/agent-search-api:latest \
  --region us-central1 --platform managed --allow-unauthenticated \
  --port 8080 --memory 2Gi --cpu 2 --timeout 300 \
  --max-instances 10 --min-instances 0 \
  --set-env-vars GCP_PROJECT=YOUR_PROJECT_ID

# Restaurant Search API
gcloud run deploy restaurant-search-api \
  --image us-central1-docker.pkg.dev/YOUR_PROJECT_ID/palate-repos/restaurant-search-api:latest \
  --region us-central1 --platform managed --allow-unauthenticated \
  --port 8080 --memory 1Gi --cpu 1 \
  --max-instances 10 --min-instances 0 \
  --set-env-vars GOOGLE_CLOUD_PROJECT=YOUR_PROJECT_ID
```

**Verify:**
```bash
gcloud run services list
gcloud run services describe agent-search-api --region us-central1 --format 'value(status.url)'
curl https://YOUR-SERVICE-URL/health
```

### Environment Variables in Cloud Run

**Via CLI:**
```bash
# API Search Service
gcloud run services update agent-search-api --region us-central1 \
  --set-env-vars GCP_PROJECT=YOUR_PROJECT_ID,GOOGLE_PLACES_API_KEY=YOUR_KEY,OPENAI_API_KEY=YOUR_KEY,DEMO_MODE=false

# Restaurant Search API
gcloud run services update restaurant-search-api --region us-central1 \
  --set-env-vars GOOGLE_CLOUD_PROJECT=YOUR_PROJECT_ID,GOOGLE_MAPS_API_KEY=YOUR_KEY,ENVIRONMENT=production
```

**Via Console:**
1. Go to [Cloud Run Console](https://console.cloud.google.com/run)
2. Click service → "Edit & Deploy New Revision"
3. "Variables & Secrets" tab → Add variables → Deploy

**Note:** Use Secret Manager for sensitive values. Cloud Run uses Application Default Credentials (ADC) for Firebase - no need to set `GOOGLE_APPLICATION_CREDENTIALS`.

---

## Environment Variables

### API Search Service

| Variable | Required | Description |
|----------|----------|-------------|
| `GCP_PROJECT` | Yes | GCP Project ID |
| `GOOGLE_APPLICATION_CREDENTIALS` | Local only | Path to Firebase service account JSON |
| `GOOGLE_PLACES_API_KEY` | Yes | Google Places API key |
| `OPENAI_API_KEY` | Yes | OpenAI API key for rank agent |
| `DEMO_MODE` | No | Use demo data (true/false) |

**Local:** Create `.env` in `backend/api_search/`  
**Cloud Run:** Set via Console/CLI, ADC handles Firebase auth

### Restaurant Search API

| Variable | Required | Description |
|----------|----------|-------------|
| `GOOGLE_MAPS_API_KEY` | Yes | Google Maps API key |
| `GOOGLE_CLOUD_PROJECT` | Yes | GCP Project ID |
| `FIREBASE_SERVICE_ACCOUNT_JSON` | Local only | Full JSON content of service account |
| `ENVIRONMENT` | No | development/production |

**Local:** Create `.env` in `backend/api/restaurant-search/`  
**Cloud Run:** Set via Console/CLI, ADC handles Firebase auth

### Frontend

Uses Firebase config files: `google-services.json` (Android), `GoogleService-Info.plist` (iOS). No env vars needed.

---

**Last Updated:** Dec 1, 2025
