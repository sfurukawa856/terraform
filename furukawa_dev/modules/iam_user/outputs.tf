output "user_name" {
  value = aws_iam_user.user.name
}

output "group_name" {
  value = aws_iam_group.admin_group.name
}

output "password" {
  value = aws_iam_user_login_profile.login_profile.encrypted_password
}