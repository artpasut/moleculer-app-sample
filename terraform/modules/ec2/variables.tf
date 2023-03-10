variable "name" {
  description = "name the purpose for the ec2 instance"
  type        = string
}

variable "tags" {
  description = "Tags to add more"
  type        = map(string)
  default     = {}
}

variable "security_group_ingress_rules" {
  description = "Map of ingress and any specific/overriding attributes to be created"
  type        = any
  default     = {}
}

variable "security_group_egress_rules" {
  description = "A map of security group egress rule defintions to add to the security group created"
  type        = any
  default     = {}
}

variable "ami" {
  type        = string
  description = "(Optional) AMI to use for the instance. Required unless launch_template is specified and the Launch Template specifes an AMI. If an AMI is specified in the Launch Template, setting ami will override the AMI specified in the Launch Template"
}

variable "instance_type" {
  description = "(Optional) The instance type to use for the instance. Updates to this field will trigger a stop/start of the EC2 instance."
  type        = string
  default     = "t2.micro"
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet relate to VPC"
  type        = string
}

variable "user_data" {
  description = "The user data to provide when launching the instance"
  type        = string
  default     = null
}

variable "key_name" {
  description = "(Optional) Key name of the Key Pair to use for the instance; which can be managed using"
  type        = string
  default     = null
}
