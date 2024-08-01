variable "user_name" {
  description = "IAMユーザーのユーザー名"
  type        = string
}

variable "group_name" {
  description = "グループ名"
  type        = string
}

variable "policy_name" {
  description = "アタッチするポリシー名"
  type        = string
}