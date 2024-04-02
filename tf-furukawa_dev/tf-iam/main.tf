provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_iam_user" "user" {
  name = "furukawa_dev"
}

resource "aws_iam_group" "admin" {
  name = "admin"
}

resource "aws_iam_group_policy_attachment" "admin_policy" {
  group      = aws_iam_group.admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_group_membership" "user_membership" {
  name = "admin_membership"

  users = [
    aws_iam_user.user.name,
  ]

  group = aws_iam_group.admin.name
}
