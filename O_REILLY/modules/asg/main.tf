resource "aws_launch_configuration" "as" {
  image_id        = "ami-0ab3794db9457b60a"
  instance_type   = var.instance_type
  security_groups = var.security_group_ids

  user_data = <<-EOF
  #!/bin/bash
  echo "Hello world!" > index.html
  nohup busybox httpd -f -p 80 &
  EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  launch_configuration = aws_launch_configuration.as.name
  vpc_zone_identifier  = var.subnet_ids

  min_size = 2
  max_size = 10
  tag {
    key                 = "Name"
    value               = "${var.project}-ec2"
    propagate_at_launch = true
  }
}