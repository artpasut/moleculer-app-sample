variable "name" {
  description = "Prefix"
}

variable "vpc_cidr" {
  description = "prduction VPC Cidr Block"
}

variable "availability_zone" {
  description = "avalability zone for this account"
  type        = list(any)
}

variable "tags" {
  description = "Tags to add more"
  type        = map(string)
  default     = {}
}
