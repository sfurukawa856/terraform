output "function_name" {
  value = aws_lambda_function.this.tags_all.Name
}

output "lambda_function_arn" {
  value = aws_lambda_function.this.arn
}