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

module "network" {
  source  = "./modules/network"
  project = var.project
  env     = var.env
}

module "security_group" {
  source  = "./modules/security_group"
  project = var.project
  env     = var.env
  vpc_id  = module.network.vpc_id
}

module "ec2" {
  source             = "./modules/ec2"
  project            = var.project
  env                = var.env
  subnet_id          = module.network.public_subnet_id
  security_group_ids = [module.security_group.ec2_sg_id]
}