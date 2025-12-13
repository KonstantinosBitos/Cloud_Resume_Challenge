# Get current AWS Account ID to construct the OIDC ARN dynamically
data "aws_caller_identity" "current" {}

locals {
  # Construct the ARN of the provider that already exists
  oidc_provider_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
}

# IAM ROLE - V2
resource "aws_iam_role" "github_deploy_role_v2" {
  name = "GitHubDeployRole_v2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = local.oidc_provider_arn
        }
        Condition = {
          StringLike = {
            # Any branch (*) in the repo can assume this role
            "token.actions.githubusercontent.com:sub" = "repo:KonstantinosBitos/Cloud_Resume_Challenge:*"
          }
        }
      }
    ]
  })

  tags = {
    Name = "GitHubDeployRole-v2"
  }
}

# Attach Admin Access to the Role
resource "aws_iam_role_policy_attachment" "github_admin_v2" {
  role       = aws_iam_role.github_deploy_role_v2.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Output the new Role ARN for GitHub Secrets
output "github_role_arn_v2" {
  value = aws_iam_role.github_deploy_role_v2.arn
}