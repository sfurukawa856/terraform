module "network" {
  // パブリックリポジトリの場合
  source = "github.com/sfurukawa856/tf-modueles//network?ref=v0.0.1"
  // プライベートリポジトリの場合
  # source = "git@github.com:sfurukawa856/tf-modueles.git//network?ref=v0.0.1"
  project = var.project
}

module "webserver-cluster" {
  source        = "github.com/sfurukawa856/tf-modueles//webserver-cluster?ref=v0.0.7"
  project       = var.project
  instance_type = "t2.micro"
  subnet_ids    = [module.network.public_subnet_1a_id, module.network.public_subnet_1c_id]
  vpc_id        = module.network.vpc_id
}