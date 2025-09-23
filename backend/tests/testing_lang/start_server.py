#!/usr/bin/env python3
"""
Quick start script for the Toronto Restaurant Agent API
"""

import subprocess
import sys
import os

def check_env_file():
    """Check if .env file exists"""
    if not os.path.exists('.env'):
        print("❌ .env file not found!")
        print("Please create a .env file with your API keys:")
        print("OPENAI_API_KEY=your_openai_api_key_here")
        print("TAVILY_API_KEY=your_tavily_api_key_here")
        return False
    return True

def install_dependencies():
    """Install required dependencies"""
    print("📦 Installing dependencies...")
    try:
        subprocess.run([sys.executable, "-m", "pip", "install", "-r", "requirements.txt"], check=True)
        print("✅ Dependencies installed successfully!")
        return True
    except subprocess.CalledProcessError:
        print("❌ Failed to install dependencies")
        return False

def start_server():
    """Start the FastAPI server"""
    print("🚀 Starting Toronto Restaurant Agent API...")
    print("=" * 50)
    
    try:
        subprocess.run([sys.executable, "main.py"])
    except KeyboardInterrupt:
        print("\n👋 Server stopped by user")
    except Exception as e:
        print(f"❌ Error starting server: {e}")

if __name__ == "__main__":
    print("🍽️  Toronto Restaurant Agent API")
    print("=" * 40)
    
    # Check if .env file exists
    if not check_env_file():
        sys.exit(1)
    
    # Ask if user wants to install dependencies
    install_deps = input("Do you want to install/update dependencies? (y/n): ").lower().strip()
    if install_deps in ['y', 'yes']:
        if not install_dependencies():
            sys.exit(1)
    
    # Start the server
    start_server()
