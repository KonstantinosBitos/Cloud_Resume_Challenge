# Cloud Resume Challenge - Backend 

This directory contains the backend code for my cloud-hosted resume, that is used to power the visitor counter for the website.


## Architecture

The backend follows a completely serverless microservices pattern:

* **AWS Lambda (Python):** A function that executes the logic to retrieve and update the visitor count.
* **Amazon DynamoDB:** A NoSQL database table (`VisitorCounter_v2`) that stores the persistent view count atomically.
* **Amazon API Gateway (HTTP API):** Provides a public HTTPS endpoint to trigger the Lambda function from the frontend.

## Tech Stack

* **Language:** Python 3.9+
* **AWS Services:** Lambda, DynamoDB, API Gateway
* **Testing:** `unittest` (Smoke tests running in CI/CD)

## API Usage

**Endpoint:** `POST /visitor_count`

**Response:**
```json
{
  "count": 42
}

## Testing

CI/CD Integration: Every push to main triggers a GitHub Action that:

Packages the Python code.

Deploys the Lambda function via Terraform.

Runs a live smoke test against the deployed API to verify health.
