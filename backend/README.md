# Cloud Resume Challenge - Backend 

This directory contains the backend code for my cloud-hosted resume, that is used to power the visitor counter for the website.

## Architecture

The backend follows a completely serverless microservices pattern:

* **AWS Lambda (Python):** Executed via API Gateway, this function handles the logic for:
    * Atomically incrementing the total view counter.
    * Hashing visitor IP addresses (SHA-256) for privacy.
    * Checking the visitor tracking table to determine uniqueness.
* **Amazon DynamoDB:** Utilizes two separate tables:
    *  **`VisitorCounter_v2`:** Stores the persistent atomic counters for `total` views and `unique` visitors.
    *  **`VisitorTracking_v2`:** Stores hashed visitor IDs with a Time-To-Live (TTL) attribute to track unique sessions (24-hour window) without storing PII.
* **Amazon API Gateway (HTTP API):** Provides a public, secure HTTPS endpoint (`POST /visitor_count`) that connects the frontend to the backend.

## Tech Stack

* **Language:** Python 3.9+ 
* **Infrastructure as Code:** Terraform
* **AWS Services:** Lambda, DynamoDB, API Gateway, CloudWatch
* **CI/CD:** GitHub Actions

## API Usage

**Endpoint:** `POST /visitor_count`

**Response:**
```json
{
  "count": 1250,
  "unique_count": 340
}
```

## Deployment

The deployment is automated via GitHub Actions. When changes are pushed to the `main` branch:

* The Python code is zipped into a deployment package.
* Terraform applies the changes to AWS (updating the Lambda function or infrastructure).
* A live smoke test runs against the API endpoint to ensure the system is healthy.
  
## File Structure

* **`lambda_function.py`**: The main Python script containing the Lambda handler and logic to interact with DynamoDB.
* **`Tests/`**: Directory containing tests.
    * **`Smoke_test.py`**: Test cases to verify the Lambda logic.




