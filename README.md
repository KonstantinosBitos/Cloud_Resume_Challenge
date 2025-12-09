# ☁️ AWS Cloud Resume Challenge

This repository contains the source code and infrastructure configuration for my Cloud Resume Challenge.

This project transforms a traditional resume into a serverless web application hosted entirely on AWS. It demonstrates skills in **Cloud Infrastructure**, **Security**, **Automation (CI/CD)**, and **Frontend/Backend Development**.

## 🔗 Quick Links
* **Live Website:** [https://konstantinos.space](https://konstantinos.space)
* **Blog Post:** [working on it]

---

## 🏗️ Architecture Overview

This project is a full-stack serverless application.

### **Frontend**
The frontend is a static site (HTML/CSS/JS) hosted on **Amazon S3** and distributed globally via **Amazon CloudFront**.
* **Security:** Secured with HTTPS using **AWS Certificate Manager (ACM)** and restricted via **Origin Access Control (OAC)**.
* **DNS:** Managed via **Namecheap** pointing to AWS.

### **Backend (In Progress)**
The backend handles the "Visitor Counter" feature.
* **Database:** **Amazon DynamoDB** (On-demand capacity) stores the view count.
* **Compute:** **AWS Lambda** (Python) updates the count atomically.
* **API:** **Amazon API Gateway** exposes the Lambda function to the frontend.

### **Automation**
* **CI/CD:** GitHub Actions pipelines automatically test and deploy changes to AWS.
* **Infrastructure as Code:** Terraform

---

## 📂 Project Structure

This repository is organized into the following components. Click the links to view technical details for each part:

| Folder | Description | Status |
| :--- | :--- | :--- |
| **[📂 frontend](./frontend)** | HTML, CSS, and JS code for the resume website. | ✅ Complete |
| **[📂 backend](./backend)** | Python Lambda functions and API definitions. | 🚧 In Progress |
| **[📂 infrastructure](./infrastructure)** | IaC templates (Terraform/SAM) for AWS resources. | 📅 Planned |

---

## 🚀 Key Learnings

### Phase 1: Cloud & Security
* Configuring **CloudFront** for global content delivery.
* Implementing **Origin Access Control (OAC)** to enforce strict security policies on S3 buckets.
* Managing DNS records and **SSL/TLS Certificates** for custom domains.

### Phase 2: Serverless Backend (Current Focus)
* Designing NoSQL schemas with **DynamoDB**.
* Writing Python **Lambda** functions for event-driven logic.

---

## Connect

**Author:** Konstantinos Bitos  
Email: [bitoskostas1@gmail.com](mailto:bitoskostas1@gmail.com)  
Medium: [@bitoskostas1](https://medium.com/@bitoskostas1)

Site: [konstantinos.space](konstantinos.space)
