data "archive_file" "lambda_hello_world" {
  type        = "zip"
  source_file  = "${path.module}/function/hello.js"
  output_path = "${path.module}/function/hello.zip"
}

resource "aws_s3_object" "lambda_hello_world" {
  bucket = var.lambda_bucket_id

  key    = "hello-world.zip"
  source = data.archive_file.lambda_hello_world.output_path

  etag = filemd5(data.archive_file.lambda_hello_world.output_path)
}

resource "aws_lambda_function" "example" {
  function_name = var.function_name
  role          = var.lambda_exec_arn
  handler       = "hello.handler"
  runtime       = "nodejs20.x"

  filename         = data.archive_file.lambda_hello_world.output_path
  source_code_hash = data.archive_file.lambda_hello_world.output_base64sha256
  tags = {
    Name = var.function_name
  }
}
