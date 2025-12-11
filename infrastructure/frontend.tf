# S3 Bucket for the Website
resource "aws_s3_bucket" "resume_bucket" {
  bucket = "konstantinos-cloud-resume-bucket" 
}

# Block Public Access (Security Best Practice)
resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.resume_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CloudFront Origin Access Control (Secure way to connect CF to S3)
resource "aws_cloudfront_origin_access_control" "cf_s3_oac" {
  name                              = "CF_S3_OAC"
  description                       = "CloudFront access to S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront Distribution (HTTPS)
resource "aws_cloudfront_distribution" "cf_dist" {
  origin {
    domain_name              = aws_s3_bucket.resume_bucket.bucket_regional_domain_name
    origin_id                = "S3Origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.cf_s3_oac.id
  }

  #  Tell CloudFront to respond to your domain
  aliases = ["konstantinos.space"]


  # UUse the ACM Certificate instead of the default
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  enabled             = true
  default_root_object = "index.html"

  #Let's not go broke
  price_class = "PriceClass_100"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3Origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

# Bucket Policy (Allow CloudFront to read S3)
resource "aws_s3_bucket_policy" "allow_cloudfront" {
  bucket = aws_s3_bucket.resume_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.resume_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.cf_dist.arn
          }
        }
      }
    ]
  })
}

# Output the CloudFront URL
output "website_url" {
  value = aws_cloudfront_distribution.cf_dist.domain_name
}