# Cloud Resume Challenge - Backend API

This directory contains the serverless backend code for the Cloud Resume Challenge. It provides an API that handles the visitor counter functionality for my resume website.

## Architecture

The backend is built using a serverless architecture on AWS:

* **Language:** Python 3.x
* **Compute:** AWS Lambda
* **Database:** Amazon DynamoDB (On-Demand)
* **API Gateway:** Amazon API Gateway (REST API)

## Project Structure

```bash
backend/
├── lambda_function.py   # The main logic for updating the database
├── tests/               # Unit and integration tests (To Be Added)
├── template.yaml        # AWS SAM Infrastructure definition (To Be Added)
└── README.md            # This file
```

## Functionality

The primary Lambda function performs the following operations:
1.  Receives a trigger from API Gateway.
2.  Connects to the DynamoDB table.
3.  Atomically increments the visitor count using `update_item`.
4.  Returns the updated count to the frontend in JSON format.

## Setup & Deployment

### Prerequisites
* AWS CLI installed and configured
* Python 3.x installed

### Current Deployment Method
* Currently deployed via AWS Console.
* *Upcoming:* Will be migrated to AWS SAM for Infrastructure as Code (IaC) deployment.

## API Usage

**Endpoint:** `https://[your-api-id].execute-api.[region].amazonaws.com/Prod/visit`

**Method:** `POST`

**Response Example:**
```json
{
  "count": 42
}
```

## Future Improvements
* Implement Infrastructure as Code (SAM/Terraform).
* Add automated unit testing.
* Configure CI/CD pipeline via GitHub Actions.