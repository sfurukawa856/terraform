output "vpc_id" {
  description = "VPC id"
  value       = aws_vpc.vpc.id
}

output "public_subnet_1a_id" {
  description = "public subnet id 1a"
  value       = aws_subnet.public_subnet_1a.id
}

output "public_subnet_1c_id" {
  description = "public subnet id 1c"
  value       = aws_subnet.public_subnet_1c.id
}

output "private_subnet_1a_id" {
  description = "private subnet id 1a"
  value       = aws_subnet.private_subnet_1a.id
}

output "private_subnet_1c_id" {
  description = "private subnet id 1c"
  value       = aws_subnet.private_subnet_1c.id
}
