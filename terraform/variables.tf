variable "stack_name" {
  description = "The name of the stack"
  type        = string
  default     = "jch-tf"
}

variable "region" {
  description = "AWS region where resources will be created."
  type        = string
  default     = "eu-west-3"
}