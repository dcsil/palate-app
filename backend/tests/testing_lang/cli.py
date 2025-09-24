"""
Simple CLI interface for the Toronto Restaurant Agent
"""

import sys
from agent import search_restaurants
from loguru import logger

def main():
    """Main CLI function"""
    print("Toronto Restaurant Agent CLI")
    print("=" * 50)
    print("Type your restaurant query and press Enter.")
    print("Type 'quit' or 'exit' to stop.")
    print("=" * 50)
    
    while True:
        try:
            # Get user input
            query = input("\nEnter your restaurant query: ").strip()
            
            # Check for exit commands
            if query.lower() in ['quit', 'exit', 'q']:
                print("\nGoodbye!")
                break
            
            # Skip empty queries
            if not query:
                print("Please enter a valid query.")
                continue
            
            print(f"\nProcessing: {query}")
            print("-" * 50)
            
            # Search for restaurants using the agent
            result = search_restaurants(query)
            
            # Display results
            print("\nRESULTS:")
            print("=" * 30)
            
            if result.restaurants and result.restaurant.name != "No restaurant found":
                restaurant = result.restaurant
                print(f"Restaurant: {restaurant.name}")
                print(f"Address: {restaurant.address}")
                print(f"Reason: {restaurant.reason}")
            else:
                print("No restaurant found matching your criteria.")
            
            # Display metrics
            print("\nMETRICS:")
            print("-" * 20)
            print(f"Processing Time: {result.metrics.processing_time_seconds:.2f} seconds")
            print(f"Total Tokens: {result.metrics.token_usage.total_tokens}")
            print(f"Estimated Cost: ${result.metrics.token_usage.estimated_cost_usd:.6f}")
            
        except KeyboardInterrupt:
            print("\n\nGoodbye!")
            break
        except Exception as e:
            print(f"\nError: {str(e)}")
            logger.error(f"CLI Error: {str(e)}")

if __name__ == "__main__":
    main()
