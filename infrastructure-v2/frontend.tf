# S3 Bucket for the Website - V2
resource "aws_s3_bucket" "resume_bucket_v2" {
  bucket = "konstantinos-cloud-resume-bucket-v2" 
}

# Block Public Access - V2
resource "aws_s3_bucket_public_access_block" "block_public_v2" {
  bucket = aws_s3_bucket.resume_bucket_v2.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CloudFront Origin Access Control - V2
resource "aws_cloudfront_origin_access_control" "cf_s3_oac_v2" {
  name                              = "CF_S3_OAC_v2"
  description                       = "CloudFront access to S3 V2"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront Distribution (HTTPS) - V2
resource "aws_cloudfront_distribution" "cf_dist_v2" {
  origin {
    domain_name              = aws_s3_bucket.resume_bucket_v2.bucket_regional_domain_name
    origin_id                = "S3Origin_v2"
    origin_access_control_id = aws_cloudfront_origin_access_control.cf_s3_oac_v2.id
  }

  # Once V2 is perfect, you can swap this back to the main domain.
  aliases = ["konstantinos.space"]

  # References the V2 certificate 
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert_v2.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  enabled             = true
  default_root_object = "index.html"
  price_class         = "PriceClass_100"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3Origin_v2"

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
  
  tags = {
    Name = "CloudFront-Distribution-v2"
  }
}

# Bucket Policy (Allow CloudFront V2 to read S3 V2)
resource "aws_s3_bucket_policy" "allow_cloudfront_v2" {
  bucket = aws_s3_bucket.resume_bucket_v2.id
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
        Resource = "${aws_s3_bucket.resume_bucket_v2.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.cf_dist_v2.arn
          }
        }
      }
    ]
  })
}

# Output the CloudFront URL
output "website_url_v2" {
  value = aws_cloudfront_distribution.cf_dist_v2.domain_name
}