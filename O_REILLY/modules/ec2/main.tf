resource "aws_instance" "ec2" {
  ami                    = "ami-0ab3794db9457b60a"
  instance_type          = var.instance_type
  vpc_security_group_ids = var.security_group_ids

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  user_data_replace_on_change = true

  tags = {
    Name = "${var.project}-ec2"
  }
}