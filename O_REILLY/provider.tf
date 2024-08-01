provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "o-reilly-tf-state-bucket"
    key = "o-reilly/terraform.tfstate"
    region = "ap-northeast-1"
    dynamodb_table = "o-reilly-tf-state-lock"
    encrypt = true
  }
}