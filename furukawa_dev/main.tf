module "iam_admin_user" {
  source      = "./modules/iam_user"
  user_name   = var.user_name
  group_name  = "admin"
  policy_name = "AdministratorAccess"
}

module "iam_role" {
  source  = "./modules/iam_role"
  project = var.project
  env     = var.env
}