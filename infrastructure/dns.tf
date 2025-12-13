data "aws_route53_zone" "main" {
  zone_id = "Z09949912KPMPC80TUMZZ" 
}

# Create the SSL Certificate for the domain
resource "aws_acm_certificate" "cert_v2" {
  provider          = aws.us_east_1 # CloudFront requires certs in us-east-1
  domain_name       = "konstantinos.space"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "SSL-Certificate-v2"
  }
}

# Create the DNS Record to Validate the certificate
resource "aws_route53_record" "cert_validation_v2" {
  for_each = {
    for dvo in aws_acm_certificate.cert_v2.domain_validation_options : dvo.domain_name => dvo
  }

  allow_overwrite = true
  name            = each.value.resource_record_name
  records         = [each.value.resource_record_value]
  ttl             = 60
  type            = each.value.resource_record_type
  
  # Use the ID from the existing zone data source
  zone_id         = data.aws_route53_zone.main.zone_id
}

# Wait for certificate validation
resource "aws_acm_certificate_validation" "cert_valid_v2" {
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.cert_v2.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation_v2 : record.fqdn]
}

# Point the domain to the CloudFront Distribution
resource "aws_route53_record" "website_alias_v2" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "konstantinos.space"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cf_dist_v2.domain_name
    zone_id                = aws_cloudfront_distribution.cf_dist_v2.hosted_zone_id
    evaluate_target_health = false
  }
}