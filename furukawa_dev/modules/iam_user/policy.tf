# ------------------------------------
# IAMポリシー
# ------------------------------------
# Administorator
data "aws_iam_policy" "admin_policy" {
  name = var.policy_name
}

# iam:ChangePassword
resource "aws_iam_policy" "change_password_policy" {
  name        = "ChangePasswordPolicy"
  description = "Policy to allow users to change their password"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "iam:ChangePassword"
        Resource = "*"
      }
    ]
  })
}

# ------------------------------------
# IAMグループにアタッチ
# ------------------------------------
resource "aws_iam_group_policy_attachment" "admin_policy" {
  group      = aws_iam_group.admin_group.name
  policy_arn = data.aws_iam_policy.admin_policy.arn
}

resource "aws_iam_group_policy_attachment" "change_password_policy" {
  group      = aws_iam_group.admin_group.name
  policy_arn = aws_iam_policy.change_password_policy.arn
}
