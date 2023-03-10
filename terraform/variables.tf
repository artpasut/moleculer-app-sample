variable "tags" {
  description = "Tags to add more"
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "name of shared resources."
  type        = string
}

variable "vpc_info" {
  description = "VPC variables related"
  type = object({
    cidr              = string
    availability_zone = list(string)
  })
}

variable "api_service_info" {
  description = "API service EC2 variables related"
  type = object({
    name              = string
    service_port      = number
    instance_type     = string
    user_data         = string
    key_name          = string
    health_check_path = string
  })
}

variable "calculator_service_info" {
  description = "calculator service EC2 variables related"
  type = object({
    name          = string
    instance_type = string
    user_data     = string
    key_name      = string
  })
}

variable "math_service_info" {
  description = "math service EC2 variables related"
  type = object({
    name          = string
    instance_type = string
    user_data     = string
    key_name      = string
  })
}

variable "nats_service_info" {
  description = "NATS service EC2 variables related"
  type = object({
    name          = string
    service_port  = number
    instance_type = string
    user_data     = string
    key_name      = string
  })
}