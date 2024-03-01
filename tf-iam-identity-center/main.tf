# ----------------------------------------------------------------
# ユーザー追加
# ----------------------------------------------------------------
resource "aws_identitystore_user" "this" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

  display_name = "furukawa"
  user_name    = "furukawa"

  name {
    given_name  = "Shohei"
    family_name = "Furukawa"
  }

  emails {
    value = var.email
  }
}

# ----------------------------------------------------------------
# グループ追加
# ----------------------------------------------------------------
resource "aws_identitystore_group" "this" {
  display_name      = "TerraformGroup"
  description       = "terraform test"
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}

# ----------------------------------------------------------------
# ユーザーとグループの紐付け
# ----------------------------------------------------------------
resource "aws_identitystore_group_membership" "this" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  group_id          = aws_identitystore_group.this.group_id
  member_id         = aws_identitystore_user.this.user_id
}

# ----------------------------------------------------------------
# オリジナルの許可セットを作成
# ----------------------------------------------------------------
resource "aws_ssoadmin_permission_set" "Administrator" {
  name         = "TestAdministratorAccess"
  description  = "Provides full access to AWS services and resources."
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
}

resource "aws_ssoadmin_permission_set" "ReadOnly" {
  name         = "TestReadOnlyAccess"
  description  = "Provides read-only access to AWS services and resources."
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
}

# ----------------------------------------------------------------
# オリジナルの許可セットにマネージドルールをアタッチ
# ----------------------------------------------------------------
resource "aws_ssoadmin_managed_policy_attachment" "Administrator" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  permission_set_arn = aws_ssoadmin_permission_set.Administrator.arn
}

resource "aws_ssoadmin_managed_policy_attachment" "ReadOnly" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  managed_policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  permission_set_arn = aws_ssoadmin_permission_set.ReadOnly.arn
}

# ----------------------------------------------------------------
# グループIDにオリジナルの許可セットをアタッチ
# ----------------------------------------------------------------
resource "aws_ssoadmin_account_assignment" "this" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.Administrator.arn

  principal_id   = aws_identitystore_group.this.group_id
  principal_type = "GROUP"

  target_id   = var.target_account_id
  target_type = "AWS_ACCOUNT"
}