variable "project_name" {
  type        = string
  description = "プロジェクト名"
}

variable "env" {
  type        = string
  description = "環境名 (dev/staging/prodなど)"
}

variable "az_count" {
  type        = number
  description = "使用するAZの数"
  default     = 2
}

variable "public_subnet_count" {
  type        = number
  description = "作成するパブリックサブネットの数"
  default     = 1
}

variable "private_subnet_count" {
  type        = number
  description = "作成するプライベートサブネットの数"
  default     = 1
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "enable_nat_gateway" {
  type        = bool
  description = "NAT Gatewayを作成するかどうか"
  default     = true
}
