resource "aws_instance" "ec2" {
  subnet_id                   = var.subnet_id
  ami                         = "ami-0ab3794db9457b60a"
  instance_type               = var.instance_type
  vpc_security_group_ids      = var.security_group_ids
  key_name                    = var.key_pair_name
  associate_public_ip_address = true

  user_data = <<-EOF
  #!/bin/bash
  yum update -y
  yum install -y httpd
  systemctl start httpd
  systemctl enable httpd
  echo "Hello, World" | sudo tee /var/www/html/index.html
  EOF

  tags = {
    Name = "${var.project}-ec2"
  }
}