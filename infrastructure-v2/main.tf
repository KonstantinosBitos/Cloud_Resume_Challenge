terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# The default provider 
provider "aws" {
  region = "eu-north-1" 

  # Apply tags to all resources to create the 2nd version
  default_tags {
    tags = {
      Project     = "CloudResumeChallenge"
      Environment = "v2"
      ManagedBy   = "Terraform"
    }
  }
}

# Special provider for CloudFront Certificates 
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"

  # Tags for the certificate resources as well
  default_tags {
    tags = {
      Project     = "CloudResumeChallenge"
      Environment = "v2"
      ManagedBy   = "Terraform"
    }
  }
}