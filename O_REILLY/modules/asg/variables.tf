variable "project" {
  type = string
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
