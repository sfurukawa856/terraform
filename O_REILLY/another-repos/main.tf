module "network" {
  // パブリックリポジトリの場合
  source = "github.com/sfurukawa856/tf-modueles//network?ref=v0.0.1"
  // プライベートリポジトリの場合
  # source = "git@github.com:sfurukawa856/tf-modueles.git//network?ref=v0.0.1"
  project = var.project
}