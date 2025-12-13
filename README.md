# AWS Cloud Resume Challenge ☁️

This repository contains the source code and infrastructure configuration for my Cloud Resume Challenge.

This project transforms a traditional resume into a serverless web application hosted entirely on AWS.

## Quick Links

* **Live Website:** [konstantinos.space](https://konstantinos.space)
* **Blog Post:** [Coming Soon]

## Architecture

This project is a full-stack serverless application designed for scalability, security, and automation.

* **Frontend:**
    * **S3 & CloudFront:** Hosting and global content delivery (CDN).
    * **Security:** HTTPS enforced via ACM certificates and Origin Access Control (OAC).
    * **DNS:** Custom domain management via Route53.

* **Backend:**
    * **API Gateway:** Exposes a secure HTTP API endpoint.
    * **AWS Lambda (Python):** Serverless compute to handle the visitor counter logic.
    * **DynamoDB:** NoSQL database for atomic visitor counting.

* **Automation:**
    * **Terraform:** Infrastructure as Code (IaC) to provision all resources.
    * **GitHub Actions:** CI/CD pipelines for testing (Python/unittest) and deployment.

## 📂 Project Structure

* **[`frontend/`](./frontend)**
    * `index.html`: Main resume content and structure.
    * `app.js`: Client-side logic to fetch visitor counts from the API.
    * `styles.css`: Styling and responsive layout.

* **[`backend/`](./backend)**
    * `lambda_function.py`: The main Python script containing the Lambda handler and logic to interact with DynamoDB.
    * `tests/`: Directory containing tests.
       * 'Smoke_test.py`: Test cases to verify the Lambda logic.

* **[`infrastructure/`](./infrastructure)**
    * `main.tf`: Provider setup and backend configuration.
    * `frontend.tf`: S3, CloudFront, and ACM resources.
    * `backend.tf`: API Gateway, Lambda, and DynamoDB resources.
    * `dns.tf`: Route53 and domain validation.
    * `oidc.tf`: IAM OpenID Connect provider for GitHub Actions.

* **`.github/workflows/`**
    * `deploy-frontend.yml`: Pipeline to sync S3 and invalidate CloudFront.
    * `deploy-backend.yml`: Pipeline to test Python code and apply Terraform.

## 📬 Connect

**Author:** Konstantinos Bitos
* **Email:** [bitoskostas1@gmail.com](mailto:bitoskostas1@gmail.com)
* **Medium:** [@bitoskostas1](https://medium.com/@bitoskostas1)
* **LinkedIn:** [Konstantinos Bitos](https://www.linkedin.com/in/konstantinosbitos/)
