# Create a zip file from the backend folder
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "../backend/lambda_function.py"     
  output_path = "../backend/func.zip"
}

# Allow logging for debugging puproses
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Allow database access
resource "aws_iam_role_policy" "dynamodb_access" {
  name = "VisitorCounterDynamoDBPolicy"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem"
        ]
        Effect   = "Allow"
        Resource = aws_dynamodb_table.visitor_counter.arn
      }
    ]
  })
}

# Existing DynamoDB Table
resource "aws_dynamodb_table" "visitor_counter" {
  name         = "VisitorCounter" 
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"                       

  attribute {
    name = "id"
    type = "S"
  }
}

# Existing IAM Role
resource "aws_iam_role" "lambda_exec" {
  name = "VisitorCountertoDynamoDB-role-aq5esh2s"          
  path = "/service-role/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Existing Lambda Function
resource "aws_lambda_function" "visitor_count_func" {
  function_name    = "VisitorCountertoDynamoDB" # 
  role             = aws_iam_role.lambda_exec.arn
  handler          = "lambda_function.lambda_handler"           
  runtime          = "python3.9"                      
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256          
}

# Create the API
resource "aws_apigatewayv2_api" "http_api" {
  name          = "VisitorCounterAPI"
  protocol_type = "HTTP"

  # Fix CORS 
  cors_configuration {
    allow_origins = ["*"] 
    allow_methods = ["POST", "GET"]
    allow_headers = ["content-type"]
  }
}

# Create a default Stage (Auto-deploy)
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

# Connect API to Lambda
resource "aws_apigatewayv2_integration" "apigw_lambda" {
  api_id             = aws_apigatewayv2_api.http_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.visitor_count_func.invoke_arn
  payload_format_version = "2.0"
}

# Define the Route (e.g., POST /visitor_count)
resource "aws_apigatewayv2_route" "count_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /visitor_count"
  target    = "integrations/${aws_apigatewayv2_integration.apigw_lambda.id}"
}

# Permission: Allow API Gateway to invoke the Lambda
resource "aws_lambda_permission" "apigw_invoke" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.visitor_count_func.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

# Output the URL to use with JS
output "api_endpoint" {
  value = aws_apigatewayv2_api.http_api.api_endpoint
}