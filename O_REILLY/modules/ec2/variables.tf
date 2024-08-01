variable "project" {
  type = string
}

variable "subnet_id" {
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