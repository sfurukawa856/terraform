module "network" {
  source  = "./modules/network"
  project = var.project
}

module "security_group" {
  source  = "./modules/security_group"
  project = var.project
  vpc_id  = module.network.vpc_id
}

# module "ec2" {
#   source             = "./modules/ec2"
#   project            = var.project
#   instance_type      = var.instance_type
#   security_group_ids = [module.security_group.ec2_sg]
# }

module "asg" {
  source             = "./modules/asg"
  project            = var.project
  instance_type      = var.instance_type
  security_group_ids = [module.security_group.ec2_sg]
  subnet_ids         = [module.network.public_subnet_1a_id, module.network.public_subnet_1c_id]
}