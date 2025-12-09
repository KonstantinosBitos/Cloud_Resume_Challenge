# Cloud Resume Challenge - Backend API

This repository contains the frontend code for my cloud-hosted resume, built as part of the [Cloud Resume Challenge](https://cloudresumechallenge.dev/).

**Live Site:** [https://konstantinos.space](https://konstantinos.space)

It provides an API that handles the visitor counter functionality for my resume website.

## Architecture

The backend is built using a serverless architecture on AWS:

* **Language:** Python 3.14
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
* Python 3.13 installed

### Current Deployment Method
* Currently deployed via AWS Console.
* *Upcoming:* Will be migrated to AWS SAM for Infrastructure as Code (IaC) deployment.

## API Usage

**Endpoint:** `https://ey7gl2zki2.execute-api.eu-north-1.amazonaws.com/MyFirstStage/`

**Method:** `POST`

**Response Example:**
```json
{ "statusCode": 200,
    "headers": {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "Content-Type",
        "Access-Control-Allow-Methods": "OPTIONS,POST,GET"
    },
    "body": "7"
}
```

## Future Improvements
* Implement Infrastructure as Code (SAM/Terraform).
* Add automated unit testing.
* Configure CI/CD pipeline via GitHub Actions.
