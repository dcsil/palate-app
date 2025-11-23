# syntax=docker/dockerfile:1
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8080 \
    PYTHONPATH=/app

WORKDIR /app

# Copy requirements first for better layer caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy all api_search content
COPY __init__.py .
COPY main.py .
COPY deps.py .
COPY archetypes.json .
COPY agents/ ./agents/
COPY models/ ./models/
COPY routers/ ./routers/
COPY services/ ./services/

# Run as non-root (Cloud Run is fine with this)
RUN useradd --create-home --shell /bin/bash app && chown -R app:app /app
USER app
ENV HOME=/home/app

EXPOSE 8080

# Shell form so $PORT expands on Cloud Run
CMD exec uvicorn main:app --host 0.0.0.0 --port ${PORT}

