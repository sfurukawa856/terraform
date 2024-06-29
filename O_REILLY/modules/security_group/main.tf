# ------------------------------------
# Security Group
# ------------------------------------
# EC2用セキュリティグループ
resource "aws_security_group" "ec2_sg" {
  name = "${var.project}-ec2-sg"
  # vpc_id      = var.vpc_id

  tags = {
    Name    = "${var.project}-ec2-sg"
    Project = var.project
  }
}

resource "aws_security_group_rule" "web_in_http" {
  security_group_id = aws_security_group.ec2_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "web_in_https" {
  security_group_id = aws_security_group.ec2_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

