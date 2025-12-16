import unittest
import requests
import json
import os

class TestAPISmoke(unittest.TestCase):
    
    def test_api_is_live(self):
        """
        Verifies the API is reachable and returns a valid visitor count.
        """
        base_url = os.environ.get("API_URL")
        
        if not base_url:
            self.fail("API_URL environment variable is missing. Cannot run smoke test.")

        API_URL = f"{base_url.rstrip('/')}/visitor_count"

        print(f"Testing API at: {API_URL}")
        
        # Make the API Call
        try:
            response = requests.post(API_URL)
        except requests.exceptions.ConnectionError:
            self.fail("Could not connect to the API")

        # Check HTTP Status Code
        self.assertEqual(
            response.status_code, 
            200, 
            f"Expected status code 200, but got {response.status_code}. Body: {response.text}"
        )

        # Check Response Structure - JSON format needed
        try:
            data = response.json()
        except json.JSONDecodeError:
            self.fail(f"API did not return valid JSON. Response text: {response.text}")

        # Check Data - There should be VisitorCount key
        self.assertIn('count', data, "Response JSON is missing the 'count' key")
        
        # Make sure the count is int
        self.assertIsInstance(data['count'], int, "count is not an integer")

        print(f"\nSUCCESS! Visitor count is: {data['count']}")

if __name__ == '__main__':
    unittest.main()
