# Cloud Resume Challenge - Infrastructure (Terraform)

This directory contains the Infrastructure as Code (IaC) for my cloud hosted resume. 
It uses Terraform to provision and manage all AWS resources automatically, ensuring the environment is reproducible, version-controlled, and consistent.

## Architecture

The infrastructure deploys a serverless full-stack application on AWS:

* **Frontend:**
    * **S3 Bucket:** Hosts the static website files (HTML, CSS, JS).
    * **CloudFront:** Content Delivery Network (CDN) for HTTPS encryption and global caching.
    * **Route53:** DNS management for the custom domain (`konstantinos.space`).
    * **ACM:** SSL/TLS Certificates for secure HTTPS connections.

* **Backend:**
    * **API Gateway (HTTP API):** Provides the public endpoint for the frontend to call.
    * **AWS Lambda:** Python function that handles the visitor counter logic.
    * **DynamoDB:** NoSQL database table (`VisitorCounter_v2`) to store the persistent visitor count.

* **CI/CD & Security:**
    * **IAM Roles:** Least-privilege roles for GitHub Actions (OIDC) and Lambda execution.
    * **Remote State:** Terraform state is stored securely in an S3 bucket with DynamoDB locking.

## File Structure

* **`main.tf`**: Provider configuration (AWS) and backend setup.
* **`frontend.tf`**: S3, CloudFront, and ACM resources.
* **`backend.tf`**: Lambda, API Gateway, and DynamoDB resources.
* **`dns.tf`**: Route53 records and domain validation.
* **`oidc.tf`**: IAM OpenID Connect provider for GitHub Actions.
* **`outputs.tf`**: Definitions of useful data returned after deployment (e.g., API Endpoint).


