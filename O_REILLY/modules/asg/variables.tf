variable "project" {
  type = string
}

variable "key_pair_name" {
  type        = string
  description = "キーペア指定"
  default     = ""
}

variable "instance_type" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "subnet_ids" {
  description = "サブネットIDs"
  type        = list(string)
}

variable "target_group_arns" {
  type        = list(string)
  description = "ALBターゲットグループのarnを指定する"
}