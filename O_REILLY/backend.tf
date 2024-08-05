# ------------------------------------
# リモートバックエンド用S3
# ------------------------------------
resource "aws_s3_bucket" "tf_state" {
  bucket = "${var.project}-tf-state-bucket"

  # S3バケット誤削除防止。削除するときはコメントアウトする
  lifecycle {
    prevent_destroy = true
  }
}

# バージョニングを有効にし、履歴がみられるようにしつつ、古いバージョンに戻すこともできる
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3上で暗号化を有効化
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.tf_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 全パブリックアクセスをブロック
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.tf_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ------------------------------------
# リモートバックエンド用DynamoDB
# ------------------------------------
resource "aws_dynamodb_table" "tf_state" {
  name         = "${var.project}-tf-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}