module "iam_admin_user" {
  source    = "./modules/tf-iam"
  user_name = var.user_name
}

provider "aws" {
  region = "ap-northeast-1"
}
