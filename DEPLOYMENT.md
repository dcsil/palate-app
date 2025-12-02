# Deployment Guide

This document provides comprehensive instructions for running the application locally and deploying it to Google Cloud Platform using Docker, Artifact Registry, and Cloud Run.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Local Development](#local-development)
  - [Frontend (Flutter)](#frontend-flutter)
  - [Backend: API Search Service](#backend-api-search-service)
  - [Backend: Restaurant Search API](#backend-restaurant-search-api)
- [Docker Setup](#docker-setup)
  - [Building Docker Images](#building-docker-images)
  - [Running Containers Locally](#running-containers-locally)
- [Google Cloud Deployment](#google-cloud-deployment)
  - [Initial Setup](#initial-setup)
  - [Artifact Registry Setup](#artifact-registry-setup)
  - [Deploying to Cloud Run](#deploying-to-cloud-run)
  - [Environment Variables in Cloud Run](#environment-variables-in-cloud-run)
- [Environment Variables Reference](#environment-variables-reference)
- [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required Software

1. **Python 3.11+**
   - Download from [python.org](https://www.python.org/downloads/)
   - Verify installation: `python --version`

2. **Node.js 18+ and npm**
   - Required for Flutter web dependencies
   - Download from [nodejs.org](https://nodejs.org/)

3. **Flutter SDK 3.0+**
   - Download from [flutter.dev](https://flutter.dev/docs/get-started/install)
   - Verify installation: `flutter --version`
   - Ensure Flutter is on the stable channel: `flutter channel stable`

4. **Docker Desktop**
   - Download from [docker.com](https://www.docker.com/products/docker-desktop)
   - Verify installation: `docker --version`

5. **Google Cloud SDK (gcloud)**
   - Download from [cloud.google.com/sdk](https://cloud.google.com/sdk/docs/install)
   - Verify installation: `gcloud --version`
   - Authenticate: `gcloud auth login`
   - Set default project: `gcloud config set project YOUR_PROJECT_ID`

6. **Git**
   - Download from [git-scm.com](https://git-scm.com/downloads)

### Required Accounts and Services

1. **Google Cloud Platform Account**
   - Create a project at [console.cloud.google.com](https://console.cloud.google.com)
   - Enable billing
   - Note your Project ID

2. **Firebase Project**
   - Create at [console.firebase.google.com](https://console.firebase.google.com)
   - Link to your GCP project
   - Enable Firestore Database

3. **API Keys**
   - Google Places API key (enable Places API in GCP Console)
   - Google Maps API key (enable Maps API in GCP Console)
   - OpenAI API key (for rank agent functionality)

4. **Service Account Credentials**
   - Create a service account in GCP Console
   - Download JSON key file
   - Grant roles: Cloud Datastore User, Firebase Admin SDK Administrator Service Agent

---

## Local Development

### Frontend (Flutter)

#### Installation

1. **Navigate to frontend directory:**
   ```bash
   cd frontend/palate
   ```

2. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

3. **Verify Flutter setup:**
   ```bash
   flutter doctor
   ```
   Ensure all checks pass (especially for your target platform: Android, iOS, or Web).

#### Running Locally

**For Web (Recommended for development):**
```bash
flutter run -d chrome
```

**For Android:**
```bash
flutter run -d android
```

**For iOS (macOS only):**
```bash
flutter run -d ios
```

The app will start on:
- **Web**: `http://localhost:PORT` (port assigned automatically)
- **Android/iOS**: Deployed to connected device/emulator

#### Environment Configuration

The Flutter app connects to backend services. Ensure backend services are running and update API endpoints in the Flutter code if needed.

**Key Configuration Files:**
- `lib/backend/` - Backend API client configurations
- `firebase/` - Firebase configuration files
- `android/app/google-services.json` - Android Firebase config
- `ios/Runner/GoogleService-Info.plist` - iOS Firebase config

---

### Backend: API Search Service

The API Search service provides AI-powered restaurant search and ranking using LangChain and OpenAI.

#### Installation

1. **Navigate to service directory:**
   ```bash
   cd backend/api_search
   ```

2. **Create virtual environment (recommended):**
   ```bash
   python -m venv .venv
   
   # On Windows:
   .venv\Scripts\activate
   
   # On macOS/Linux:
   source .venv/bin/activate
   ```

3. **Install dependencies:**
   ```bash
   pip install --upgrade pip
   pip install -r requirements.txt
   ```

#### Environment Setup

1. **Create `.env` file in `backend/api_search/`:**
   ```env
   # Google Cloud Platform
   GCP_PROJECT=your-gcp-project-id
   GOOGLE_APPLICATION_CREDENTIALS=./firebase-service.json
   
   # Google Places API
   GOOGLE_PLACES_API_KEY=your-google-places-api-key
   
   # OpenAI API (optional, depending on which LLM to use)
   OPENAI_API_KEY=your-openai-api-key
   
   # Demo Mode (optional - set to true for testing without API calls)
   DEMO_MODE=false
   ```

2. **Firebase Service Account:**
   - Download service account JSON from Firebase Console
   - Save as `firebase-service.json` in `backend/api_search/`
   - Ensure file has Firestore read/write permissions

3. **Enable Required APIs:**
   - Google Places API
   - Firestore API
   - (In GCP Console)

#### Running Locally

**Development mode (with auto-reload):**
```bash
cd backend/api_search
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

**Production mode:**
```bash
uvicorn main:app --host 0.0.0.0 --port 8000
```

The API will be available at:
- **API**: `http://127.0.0.1:8000`
- **Interactive Docs**: `http://127.0.0.1:8000/docs`
- **Alternative Docs**: `http://127.0.0.1:8000/redoc`
- **Health Check**: `http://127.0.0.1:8000/health`

#### API Endpoints

- `GET /health` - Health check endpoint
- `POST /agent/search` - Search restaurants (Google Places or Firestore)
- `POST /agent/rank` - Rank restaurants by palate archetype

---

### Backend: Restaurant Search API

The Restaurant Search API provides restaurant details, location information, and Firebase integration.

#### Installation

1. **Navigate to service directory:**
   ```bash
   cd backend/api/restaurant-search
   ```

2. **Create virtual environment (recommended):**
   ```bash
   python -m venv venv
   
   # On Windows:
   venv\Scripts\activate
   
   # On macOS/Linux:
   source venv/bin/activate
   ```

3. **Install dependencies:**
   ```bash
   pip install --upgrade pip
   pip install -r requirements.txt
   ```

#### Environment Setup

1. **Create `.env` file in `backend/api/restaurant-search/`:**
   ```env
   # Google Maps API Key
   GOOGLE_MAPS_API_KEY=your-google-maps-api-key
   
   # Google Cloud Project ID (required for Application Default Credentials)
   GOOGLE_CLOUD_PROJECT=your-project-id
   
   # Firebase Service Account (Optional - for local development only)
   # Set this environment variable with the JSON content of your service account key
   # FIREBASE_SERVICE_ACCOUNT_JSON={"type":"service_account",...}
   
   # Environment (optional)
   ENVIRONMENT=development
   ```

2. **Firebase Setup:**
   - For local development, you can set `FIREBASE_SERVICE_ACCOUNT_JSON` with the full JSON content
   - For production/Cloud Run, use Application Default Credentials (ADC)
   - Ensure service account has Firestore permissions

3. **Enable Required APIs:**
   - Google Maps API (Places API, Geocoding API)
   - Firestore API
   - (In GCP Console)

#### Running Locally

**Development mode (with auto-reload):**
```bash
cd backend/api/restaurant-search
uvicorn main:app --reload --host 0.0.0.0 --port 8001
```

**Production mode:**
```bash
uvicorn main:app --host 0.0.0.0 --port 8001
```

The API will be available at:
- **API**: `http://127.0.0.1:8001`
- **Interactive Docs**: `http://127.0.0.1:8001/docs`
- **Health Check**: `http://127.0.0.1:8001/health`

#### API Endpoints

- `GET /` - Root endpoint with service info
- `GET /health` - Health check
- `GET /ready` - Readiness check
- `POST /location` - Get location info from coordinates
- `POST /restaurants/search` - Search restaurants in radius
- `POST /restaurant_details` - Get single restaurant details
- `POST /multiple_restaurant_details` - Get multiple restaurant details concurrently
- `DELETE /restaurant` - Delete restaurant from database

---

## Docker Setup

### Building Docker Images

#### API Search Service

1. **Navigate to service directory:**
   ```bash
   cd backend/api_search
   ```

2. **Build Docker image:**
   ```bash
   docker build -t agent-search-api:latest .
   ```

3. **Verify image:**
   ```bash
   docker images | grep agent-search-api
   ```

#### Restaurant Search API

1. **Navigate to service directory:**
   ```bash
   cd backend/api/restaurant-search
   ```

2. **Build Docker image:**
   ```bash
   docker build -t restaurant-search-api:latest .
   ```

3. **Verify image:**
   ```bash
   docker images | grep restaurant-search-api
   ```

### Running Containers Locally

#### API Search Service

```bash
docker run -d \
  --name agent-search-api \
  -p 8000:8080 \
  -e GCP_PROJECT=your-gcp-project-id \
  -e GOOGLE_PLACES_API_KEY=your-key \
  -e OPENAI_API_KEY=your-key \
  -e GOOGLE_APPLICATION_CREDENTIALS=/app/firebase-service.json \
  -v /path/to/firebase-service.json:/app/firebase-service.json:ro \
  agent-search-api:latest
```

**Note:** Replace paths and keys with your actual values.

#### Restaurant Search API

```bash
docker run -d \
  --name restaurant-search-api \
  -p 8001:8080 \
  -e GOOGLE_MAPS_API_KEY=your-key \
  -e GOOGLE_CLOUD_PROJECT=your-project-id \
  -e FIREBASE_SERVICE_ACCOUNT_JSON='{"type":"service_account",...}' \
  restaurant-search-api:latest
```

**Note:** For `FIREBASE_SERVICE_ACCOUNT_JSON`, provide the full JSON content as a single-line string.

#### Verify Containers

```bash
# Check running containers
docker ps

# View logs
docker logs agent-search-api
docker logs restaurant-search-api

# Stop containers
docker stop agent-search-api restaurant-search-api

# Remove containers
docker rm agent-search-api restaurant-search-api
```

---

## Google Cloud Deployment

### Initial Setup

1. **Authenticate with Google Cloud:**
   ```bash
   gcloud auth login
   gcloud auth application-default login
   ```

2. **Set your project:**
   ```bash
   gcloud config set project YOUR_PROJECT_ID
   ```

3. **Enable required APIs:**
   ```bash
   gcloud services enable \
     run.googleapis.com \
     cloudbuild.googleapis.com \
     artifactregistry.googleapis.com \
     firestore.googleapis.com
   ```

4. **Set up billing:**
   - Ensure billing is enabled for your project
   - Cloud Run has a free tier, but usage beyond free tier requires billing

### Artifact Registry Setup

Artifact Registry is Google Cloud's container image registry. We'll use it instead of Container Registry (deprecated).

1. **Create Artifact Registry repository:**
   ```bash
   gcloud artifacts repositories create palate-repos \
     --repository-format=docker \
     --location=us-central1 \
     --description="Docker repository for Palate application"
   ```

2. **Configure Docker authentication:**
   ```bash
   gcloud auth configure-docker us-central1-docker.pkg.dev
   ```

3. **Verify repository:**
   ```bash
   gcloud artifacts repositories list
   ```

### Deploying to Cloud Run

#### Method 1: Using Cloud Build (Recommended)

Cloud Build automatically builds, tests, and deploys your services using the `cloudbuild.yaml` files.

**API Search Service:**

1. **Navigate to service directory:**
   ```bash
   cd backend/api_search
   ```

2. **Submit build:**
   ```bash
   gcloud builds submit --config cloudbuild.yaml
   ```

   This will:
   - Run tests
   - Build Docker image
   - Push to Artifact Registry
   - Deploy to Cloud Run

**Restaurant Search API:**

1. **Navigate to service directory:**
   ```bash
   cd backend/api/restaurant-search
   ```

2. **Submit build:**
   ```bash
   gcloud builds submit --config cloudbuild.yaml
   ```

#### Method 2: Manual Deployment

**Build and push images manually:**

1. **Build and tag for Artifact Registry:**
   ```bash
   # API Search Service
   cd backend/api_search
   docker build -t us-central1-docker.pkg.dev/YOUR_PROJECT_ID/palate-repos/agent-search-api:latest .
   
   # Restaurant Search API
   cd ../api/restaurant-search
   docker build -t us-central1-docker.pkg.dev/YOUR_PROJECT_ID/palate-repos/restaurant-search-api:latest .
   ```

2. **Push images:**
   ```bash
   docker push us-central1-docker.pkg.dev/YOUR_PROJECT_ID/palate-repos/agent-search-api:latest
   docker push us-central1-docker.pkg.dev/YOUR_PROJECT_ID/palate-repos/restaurant-search-api:latest
   ```

3. **Deploy to Cloud Run:**

   **API Search Service:**
   ```bash
   gcloud run deploy agent-search-api \
     --image us-central1-docker.pkg.dev/YOUR_PROJECT_ID/palate-repos/agent-search-api:latest \
     --region us-central1 \
     --platform managed \
     --allow-unauthenticated \
     --port 8080 \
     --memory 2Gi \
     --cpu 2 \
     --timeout 300 \
     --max-instances 10 \
     --min-instances 0 \
     --set-env-vars GCP_PROJECT=YOUR_PROJECT_ID
   ```

   **Restaurant Search API:**
   ```bash
   gcloud run deploy restaurant-search-api \
     --image us-central1-docker.pkg.dev/YOUR_PROJECT_ID/palate-repos/restaurant-search-api:latest \
     --region us-central1 \
     --platform managed \
     --allow-unauthenticated \
     --port 8080 \
     --memory 1Gi \
     --cpu 1 \
     --max-instances 10 \
     --min-instances 0 \
     --set-env-vars GOOGLE_CLOUD_PROJECT=YOUR_PROJECT_ID
   ```

#### Verify Deployment

1. **List services:**
   ```bash
   gcloud run services list
   ```

2. **Get service URLs:**
   ```bash
   gcloud run services describe agent-search-api --region us-central1 --format 'value(status.url)'
   gcloud run services describe restaurant-search-api --region us-central1 --format 'value(status.url)'
   ```

3. **Test endpoints:**
   ```bash
   curl https://YOUR-SERVICE-URL/health
   ```

### Environment Variables in Cloud Run

Set environment variables using the Cloud Console or gcloud CLI:

**Using gcloud CLI:**

**API Search Service:**
```bash
gcloud run services update agent-search-api \
  --region us-central1 \
  --set-env-vars GCP_PROJECT=YOUR_PROJECT_ID,GOOGLE_PLACES_API_KEY=YOUR_KEY,OPENAI_API_KEY=YOUR_KEY,DEMO_MODE=false
```

**Restaurant Search API:**
```bash
gcloud run services update restaurant-search-api \
  --region us-central1 \
  --set-env-vars GOOGLE_CLOUD_PROJECT=YOUR_PROJECT_ID,GOOGLE_MAPS_API_KEY=YOUR_KEY,ENVIRONMENT=production
```

**Using Cloud Console:**

1. Go to [Cloud Run Console](https://console.cloud.google.com/run)
2. Click on your service
3. Click "Edit & Deploy New Revision"
4. Go to "Variables & Secrets" tab
5. Add environment variables
6. Click "Deploy"

**Important Notes:**
- For sensitive values (API keys), use **Secret Manager** instead of environment variables
- Cloud Run automatically uses Application Default Credentials (ADC) for Firebase/Firestore
- No need to set `GOOGLE_APPLICATION_CREDENTIALS` in Cloud Run (uses ADC)

---

## Environment Variables Reference

### API Search Service (`backend/api_search`)

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `GCP_PROJECT` | Yes | Google Cloud Project ID | `palate-mvp` |
| `GOOGLE_APPLICATION_CREDENTIALS` | Local only | Path to Firebase service account JSON | `./firebase-service.json` |
| `GOOGLE_PLACES_API_KEY` | Yes | Google Places API key | `AIza...` |
| `OPENAI_API_KEY` | Yes | OpenAI API key for rank agent | `sk-...` |
| `DEMO_MODE` | No | Use hardcoded demo data (true/false) | `false` |

**Local Development:**
- Create `.env` file in `backend/api_search/`
- Include all required variables

**Cloud Run:**
- Set via Cloud Console or gcloud CLI
- `GOOGLE_APPLICATION_CREDENTIALS` not needed (uses ADC)

### Restaurant Search API (`backend/api/restaurant-search`)

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `GOOGLE_MAPS_API_KEY` | Yes | Google Maps API key | `AIza...` |
| `GOOGLE_CLOUD_PROJECT` | Yes | Google Cloud Project ID | `palate-mvp` |
| `FIREBASE_SERVICE_ACCOUNT_JSON` | Local only | Full JSON content of service account | `{"type":"service_account",...}` |
| `ENVIRONMENT` | No | Environment name (development/production) | `production` |

**Local Development:**
- Create `.env` file in `backend/api/restaurant-search/`
- Include all required variables
- For `FIREBASE_SERVICE_ACCOUNT_JSON`, provide full JSON as single-line string

**Cloud Run:**
- Set via Cloud Console or gcloud CLI
- `FIREBASE_SERVICE_ACCOUNT_JSON` not needed (uses ADC)

### Frontend (Flutter)

The Flutter app uses Firebase configuration files:
- `android/app/google-services.json` (Android)
- `ios/Runner/GoogleService-Info.plist` (iOS)
- Firebase web config in code

No additional environment variables needed for local development.

---

**Last Updated:** Dec 1, 2025