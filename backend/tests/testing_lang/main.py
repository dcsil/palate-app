"""
Start the Toronto Restaurant Agent FastAPI Server
"""

import uvicorn

if __name__ == "__main__":
    print("🚀 Starting Toronto Restaurant Agent FastAPI Server...")
    print("📖 API Documentation available at: http://localhost:8000/docs")
    print("🔗 Health check at: http://localhost:8000/health")
    print("🍽️  Restaurant recommendations at: http://localhost:8000/recommend")
    print("=" * 60)
    
    uvicorn.run(
        "server:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
        log_level="info"
    )
