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
```

## Deployment

The deployment is automated via GitHub Actions. When changes are pushed to the `main` branch:

* **Package**: The Python code is zipped into a deployment package.
* **Provision**: Terraform applies the changes to AWS (updating the Lambda function or infrastructure).
* **Verify**: A live smoke test runs against the API endpoint to ensure the system is healthy.

