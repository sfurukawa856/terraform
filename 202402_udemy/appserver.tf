# ------------------------------------
# key pair
# ------------------------------------
resource "aws_key_pair" "key_pair" {
  key_name   = "${var.project}-${var.environment}-keypair"
  public_key = file("./src/udemy-app-dev-keypair.pub")

  tags = {
    Name    = "${var.project}-${var.environment}-keypair"
    Project = var.project
    Env     = var.environment
  }
}