variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "execution_role_policies" {
  description = "Additional policies to attach to the execution role"
  type        = list(string)
  default     = []
}

variable "task_role_policies" {
  description = "Additional policies to attach to the task role"
  type        = list(string)
  default     = []
}