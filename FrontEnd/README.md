# AWS Cloud Resume Challenge - Frontend ☁️

This repository contains the frontend code for my cloud-hosted resume, built as part of the [Cloud Resume Challenge](https://cloudresumechallenge.dev/).

**Live Site:** [https://konstantinos.space](https://konstantinos.space)

## 🏗️ Architecture
This static website is deployed on AWS using a serverless architecture:
* **Amazon S3:** Stores the HTML and CSS files.
* **Amazon CloudFront:** Content Delivery Network (CDN) for global caching and HTTPS enforcement.
* **AWS Certificate Manager (ACM):** Provides the SSL certificate for secure connections.
* **Origin Access Control (OAC):** Secures the S3 bucket so it is only accessible via CloudFront (no public bucket access).

## 🛠️ Tech Stack
* **Frontend:** HTML5, CSS3, JavaScript
* **Infrastructure:** AWS S3, CloudFront, Route 53 / Namecheap DNS

## 🚀 Next Steps - **COMPLETED**

I am currently working on the backend, which will include:
* **DynamoDB** table for visitor counting.
* **AWS Lambda** (Python) for serverless logic.
* **API Gateway** to connect the frontend to the backend.
