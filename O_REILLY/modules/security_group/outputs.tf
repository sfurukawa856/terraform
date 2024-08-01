output "key_pair" {
  value = aws_key_pair.ssh_key.key_name
}

output "ec2_sg" {
  value = aws_security_group.ec2_sg.id
}

output "alb_sg" {
  value = aws_security_group.alb_sg.id
}

output "asg_sg" {
  value = aws_security_group.asg_sg.id
}