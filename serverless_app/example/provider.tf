provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      env = "test"
      hashicorp-learn = "lambda-api-gateway"
    }
  }
}
