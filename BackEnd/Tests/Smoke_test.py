import unittest
import requests
import json
import os

class TestAPISmoke(unittest.TestCase):
    # READ FROM ENV VARIABLE
    BASE_URL = os.environ.get("API_URL", "https://ituez63k3l.execute-api.eu-north-1.amazonaws.com")

    def test_api_is_live(self):
        """
        Verifies the API is reachable and returns a valid visitor count.
        """
        # CONSTRUCT FULL URL
        if self.BASE_URL.endswith('/'):
            full_url = f"{self.BASE_URL}visitor_count"
        else:
            full_url = f"{self.BASE_URL}/visitor_count"

        print(f"Testing API at: {full_url}")
        
        # Make the API Call
        try:
            response = requests.post(full_url)
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
        if isinstance(data, dict):
            self.assertIn('VisitorCount', data, "Response JSON is missing the 'VisitorCount' key")
            count_val = data['VisitorCount']
        else:
            # Fallback if your API returns just a raw number
            count_val = data

        # Make sure the count is int (or can be cast to int)
        try:
            int(count_val)
        except ValueError:
            self.fail(f"Visitor count is not an integer: {count_val}")

        print(f"\nSUCCESS! Visitor count is: {count_val}")

if __name__ == '__main__':
    unittest.main()