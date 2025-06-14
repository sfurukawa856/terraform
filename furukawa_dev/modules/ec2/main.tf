resource "aws_instance" "web_server" {
  ami                         = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = true

  tags = {
    Name = "${var.project}-${var.env}-web-server"
  }
}

output "instance_id" {
  value = aws_instance.web_server.id
}

output "public_ip" {
  value = aws_instance.web_server.public_ip
}
