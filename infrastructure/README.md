# Cloud Resume Challenge - Infrastructure

This directory contains the Infrastructure as Code for my cloud hosted resume. 
It uses Terraform to provision and manage all AWS resources automatically, ensuring the environment is reproducible, version-controlled, and consistent.

When applied, this Terraform configuration performs the following actions:

1.  **Sets up Security:** Configures OIDC authentication so GitHub Actions can deploy safely without long-lived access keys.
2.  **Provisions Storage:** Creates an S3 bucket for the website and blocks all public access (enforcing security best practices).
3.  **Configures Networking:** Deploys a CloudFront distribution to serve the site globally via HTTPS, using OAC (Origin Access Control) to securely fetch files from S3.
4.  **Manages DNS:** Automatically validates SSL certificates via ACM and creates DNS "A" records in Route53 to point the custom domain to the CDN.
5.  **Deploys Backend:** Zips the Python code, creates the Lambda function, and sets up an API Gateway endpoint that triggers the function.
6.  **Initializes Database:** Creates a DynamoDB table with on-demand capacity to store visitor counts cost-effectively.

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
