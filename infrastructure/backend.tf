# Create a zip file from the backend folder - V2
data "archive_file" "lambda_zip_v2" {
  type        = "zip"
  source_file = "../backend/lambda_function.py"      
  output_path = "../backend/func_v2.zip"
}

# Existing DynamoDB Table - V2
resource "aws_dynamodb_table" "visitor_counter_v2" {
  name         = "VisitorCounter_v2" 
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"                        

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name = "VisitorCounterTable-v2"
  }
}

# IAM Role for Lambda - V2
resource "aws_iam_role" "lambda_exec_v2" {
  name = "VisitorCounterRole_v2"       
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

# Allow logging for debugging purposes - V2
resource "aws_iam_role_policy_attachment" "lambda_logs_v2" {
  role       = aws_iam_role.lambda_exec_v2.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Allow database access - V2
resource "aws_iam_role_policy" "dynamodb_access_v2" {
  name = "VisitorCounterDynamoDBPolicy_v2"
  role = aws_iam_role.lambda_exec_v2.id

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
        # Only allow access to the V2 table
        Resource = aws_dynamodb_table.visitor_counter_v2.arn
      }
    ]
  })
}

# Lambda Function - V2
resource "aws_lambda_function" "visitor_count_func_v2" {
  function_name    = "VisitorCountertoDynamoDB_v2" # 
  role             = aws_iam_role.lambda_exec_v2.arn
  handler          = "lambda_function.lambda_handler"            
  runtime          = "python3.9"                       
  filename         = data.archive_file.lambda_zip_v2.output_path
  source_code_hash = data.archive_file.lambda_zip_v2.output_base64sha256          

  # Pass the new table name to Python
  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.visitor_counter_v2.name
    }
  }
}

# Create the API - V2
resource "aws_apigatewayv2_api" "http_api_v2" {
  name          = "VisitorCounterAPI_v2"
  protocol_type = "HTTP"

  # Fix CORS 
  cors_configuration {
    allow_origins = ["*"] 
    allow_methods = ["POST", "GET"]
    allow_headers = ["content-type"]
  }
}

# Create a default Stage (Auto-deploy) - V2
resource "aws_apigatewayv2_stage" "default_v2" {
  api_id      = aws_apigatewayv2_api.http_api_v2.id
  name        = "$default"
  auto_deploy = true
}

# Connect API to Lambda - V2
resource "aws_apigatewayv2_integration" "apigw_lambda_v2" {
  api_id                 = aws_apigatewayv2_api.http_api_v2.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.visitor_count_func_v2.invoke_arn
  payload_format_version = "2.0"
}

# Define the Route (POST / visitor_count) - V2
resource "aws_apigatewayv2_route" "count_route_v2" {
  api_id    = aws_apigatewayv2_api.http_api_v2.id
  route_key = "POST /visitor_count"
  target    = "integrations/${aws_apigatewayv2_integration.apigw_lambda_v2.id}"
}

# Allow API Gateway V2 to invoke the Lambda V2
resource "aws_lambda_permission" "apigw_invoke_v2" {
  statement_id  = "AllowExecutionFromAPIGateway_v2"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.visitor_count_func_v2.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api_v2.execution_arn}/*/*"
}

# Output the URL to use with JS - V2
output "api_endpoint_v2" {
  value = aws_apigatewayv2_api.http_api_v2.api_endpoint
}