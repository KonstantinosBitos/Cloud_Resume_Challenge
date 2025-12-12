import unittest
import requests
import json

class TestAPISmoke(unittest.TestCase):
    API_URL = "https://ey7gl2zki2.execute-api.eu-north-1.amazonaws.com/MyFirstStage"

    def test_api_is_live(self):
        """
        Verifies the API is reachable and returns a valid visitor count.
        """
        print(f"Testing API at: {self.API_URL}")
        
        # Make the API Call
        try:
            response = requests.post(self.API_URL)
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
        self.assertIn('VisitorCount', data, "Response JSON is missing the 'VisitorCount' key")
        
        # Make sure the count is int
        self.assertIsInstance(data['VisitorCount'], int, "Visitor count is not an integer")

        print(f"\nSUCCESS! Visitor count is: {data['VisitorCount']}")

if __name__ == '__main__':
    unittest.main()