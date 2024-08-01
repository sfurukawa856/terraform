# ------------------------------------
# key pair
# ------------------------------------
resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = file("./.ssh/ec2keypair.pub")
}

# ------------------------------------
# ALB用セキュリティグループ
# ------------------------------------
resource "aws_security_group" "alb_sg" {
  name   = "${var.project}-alb-sg"
  vpc_id = var.vpc_id

  tags = {
    Name    = "${var.project}-alb-sg"
    Project = var.project
  }
}

resource "aws_security_group_rule" "alb_in_http" {
  security_group_id = aws_security_group.alb_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_out_http" {
  security_group_id        = aws_security_group.alb_sg.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = aws_security_group.asg_sg.id
}

# ------------------------------------
# EC2用セキュリティグループ
# ------------------------------------
resource "aws_security_group" "ec2_sg" {
  name   = "${var.project}-ec2-sg"
  vpc_id = var.vpc_id

  tags = {
    Name    = "${var.project}-ec2-sg"
    Project = var.project
  }
}

resource "aws_security_group_rule" "ec2_in_http" {
  security_group_id = aws_security_group.ec2_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ec2_in_ssh" {
  security_group_id = aws_security_group.ec2_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["153.216.113.64/32"]
}

resource "aws_security_group_rule" "ec2_out_all" {
  security_group_id = aws_security_group.ec2_sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

# ------------------------------------
# ASG用セキュリティグループ
# ------------------------------------
resource "aws_security_group" "asg_sg" {
  name   = "${var.project}-asg-sg"
  vpc_id = var.vpc_id

  tags = {
    Name    = "${var.project}-asg-sg"
    Project = var.project
  }
}

resource "aws_security_group_rule" "asg_in_http" {
  security_group_id        = aws_security_group.asg_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "asg_in_ssh" {
  security_group_id = aws_security_group.asg_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["153.216.113.64/32"]
}

resource "aws_security_group_rule" "asg_out_all" {
  security_group_id = aws_security_group.asg_sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}
