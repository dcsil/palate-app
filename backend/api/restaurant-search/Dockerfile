# syntax=docker/dockerfile:1
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8080 \
    PYTHONPATH=/app

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy only this service’s code
COPY . .

# Run as non-root (Cloud Run is fine with this)
RUN useradd --create-home --shell /bin/bash app && chown -R app:app /app
USER app
ENV HOME=/home/app

EXPOSE 8080

# Shell form so $PORT expands on Cloud Run
CMD exec uvicorn main:app --host 0.0.0.0 --port ${PORT}
