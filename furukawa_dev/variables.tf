variable "user_name" {
  description = "IAMユーザーのユーザー名"
  type        = string
}

variable "project" {
  default = "my-app"
}

variable "env" {
  default = "dev"
}