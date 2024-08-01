module "network" {
  source  = "./modules/network"
  project = var.project
}

module "security_group" {
  source  = "./modules/security_group"
  project = var.project
  vpc_id  = module.network.vpc_id
}

module "ec2" {
  source             = "./modules/ec2"
  project            = var.project
  subnet_id          = module.network.public_subnet_1a_id
  key_pair_name      = module.security_group.key_pair
  instance_type      = var.instance_type
  security_group_ids = [module.security_group.ec2_sg]
}

module "asg" {
  source             = "./modules/asg"
  project            = var.project
  key_pair_name      = module.security_group.key_pair
  instance_type      = var.instance_type
  security_group_ids = [module.security_group.asg_sg]
  subnet_ids         = [module.network.public_subnet_1a_id, module.network.public_subnet_1c_id]
  target_group_arns  = [module.alb.target_group_arn]
}

module "alb" {
  source             = "./modules/alb"
  project            = var.project
  security_group_ids = [module.security_group.alb_sg]
  subnet_ids         = [module.network.public_subnet_1a_id, module.network.public_subnet_1c_id]
  vpc_id             = module.network.vpc_id
}
