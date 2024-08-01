resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "aws_launch_configuration" "as" {
  name            = "${var.project}-as-${random_string.suffix.result}"
  image_id        = "ami-0ab3794db9457b60a"
  instance_type   = var.instance_type
  security_groups = var.security_group_ids
  key_name        = var.key_pair_name

  user_data = <<-EOF
  #!/bin/bash
  # Install Apache
  yum update -y
  yum install -y httpd

  systemctl start httpd
  systemctl enable httpd

  echo "Hello, World" | sudo tee /var/www/html/index.html
  EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  launch_configuration = aws_launch_configuration.as.name
  vpc_zone_identifier  = var.subnet_ids

  target_group_arns = var.target_group_arns
  health_check_type = "ELB"

  desired_capacity = 2
  min_size         = 1
  max_size         = 2
  tag {
    key                 = "Name"
    value               = "${var.project}-asg"
    propagate_at_launch = true
  }
}