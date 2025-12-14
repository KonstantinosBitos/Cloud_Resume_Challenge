# Cloud Resume Challenge - Frontend 

This directory contains the frontend code for my cloud-hosted resume.

## Architecture

The website is a static site deployed on AWS using a serverless architecture:

* **Amazon S3:** Hosts the static HTML, CSS, and JavaScript files.
* **Amazon CloudFront:** Content Delivery Network (CDN) for global low-latency caching and HTTPS enforcement.
* **AWS Certificate Manager (ACM):** Provisions the SSL/TLS certificate for secure connections.
* **Origin Access Control (OAC):** Restricts S3 bucket access so content is only viewable through CloudFront (no direct public access).

## Tech Stack

* **Frontend:** HTML5, CSS3, JavaScript
* **Infrastructure:** AWS S3, CloudFront, Route 53
* **CI/CD:** GitHub Actions (Automatic invalidation and sync on push)

## Deployment

The deployment is automated via GitHub Actions. When changes are pushed to the `main` branch:
* Files are synced to the S3 bucket.
* The CloudFront cache is invalidated to ensure users see the latest version immediately.

## File Structure

* **`index.html`**: The main entry point for the website, containing the resume structure and content.
* **`styles.css`**: Contains all the styling rules, layout definitions, and responsive design adjustments.
* **`app.js`**: JavaScript logic that handles the API call to fetch and update the visitor count.
