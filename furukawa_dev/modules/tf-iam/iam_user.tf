resource "aws_iam_user" "user" {
  name          = var.user_name
  force_destroy = true
}

resource "aws_iam_user_login_profile" "login_profile" {
  user                    = aws_iam_user.user.name
  pgp_key                 = filebase64("./modules/tf-iam/cert/furukawa.public.gpg")
  password_length         = 20
  password_reset_required = true
}

resource "aws_iam_user_group_membership" "admin_membership" {
  user = aws_iam_user.user.name
  groups = [
    aws_iam_group.admin_group.name
  ]
}

output "encrypted_password" { 
  value = aws_iam_user_login_profile.login_profile.encrypted_password
}
