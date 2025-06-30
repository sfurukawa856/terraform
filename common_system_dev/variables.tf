variable "project" {
  type        = string
  description = "Project name"
  default = "common-system"
}

variable "env" {
  type        = string
  description = "Environment name"
  default = "dev"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "ap-northeast-1"
}