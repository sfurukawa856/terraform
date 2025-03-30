module "network" {
  source               = "../modules/network"
  project_name         = "udemy-ecs"
  env                  = "dev"
  az_count             = 1
  public_subnet_count  = 1
  private_subnet_count = 2
  vpc_cidr             = "10.0.0.0/16"
  enable_nat_gateway   = false
}