# ------------------------------------
# Bucket for Lambda
# ------------------------------------
resource "random_pet" "lambda_bucket_name" {
  prefix = "learn-terraform-functions"
  length = 4
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id
}

resource "aws_s3_bucket_ownership_controls" "lambda_bucket" {
  bucket = aws_s3_bucket.lambda_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "lambda_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.lambda_bucket]

  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

# ------------------------------------
# Lambda
# ------------------------------------
module "lambda" {
  source           = "./modules/lambda"
  lambda_bucket_id = aws_s3_bucket.lambda_bucket.id
  function_name    = "hello-world-func"
  lambda_exec_arn  = aws_iam_role.lambda_exec.arn
}

# ------------------------------------
# CloudWatch Logs
# ------------------------------------
resource "aws_cloudwatch_log_group" "hello_world" {
  name              = "/aws/lambda/hello-world-func"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name              = "/aws/api_gw/accesslogs"
  retention_in_days = 1
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

output "function_name" {
  description = "Name of the Lambda function."
  value       = module.lambda.function_name
}

module "apigateway" {
  source               = "./modules/apigateway"
  api_name             = "my-api"
  cloudwatchlogs_arn   = aws_cloudwatch_log_group.api_gw.arn
  lambda_arn           = module.lambda.lambda_function_arn
  lambda_function_name = module.lambda.function_name
}

output "base_url" {
  description = "Base URL for API Gateway stage."
  value = module.apigateway.invoke_url
}