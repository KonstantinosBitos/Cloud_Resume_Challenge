
# Create the Hosted Zone in AWS
resource "aws_route53_zone" "main" {
  name = "konstantinos.space"
}

# Create the SSL Certificate (for HTTPS)
# CloudFront requires certificates to be in us-east-1 (N. Virginia) - Fixed in main file
resource "aws_acm_certificate" "cert" {
  provider          = aws.us_east_1 
  domain_name       = "konstantinos.space"
  validation_method = "DNS"


  lifecycle {
    create_before_destroy = true
  }
}

# Create the DNS Record to Validate the Certificate
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => dvo
  }

  allow_overwrite = true
  name            = each.value.resource_record_name
  records         = [each.value.resource_record_value]
  ttl             = 60
  type            = each.value.resource_record_type
  zone_id         = aws_route53_zone.main.zone_id
}

# Wait for Certificate Validation
resource "aws_acm_certificate_validation" "cert_valid" {
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

# Point the Domain to CloudFront 
resource "aws_route53_record" "website_alias" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "konstantinos.space"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cf_dist.domain_name
    zone_id                = aws_cloudfront_distribution.cf_dist.hosted_zone_id
    evaluate_target_health = false
  }
}