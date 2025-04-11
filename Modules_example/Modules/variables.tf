# What is variable
# Using variables in terraform configurations makes our deployments more dynamic
# We create variable.tf file to store variables and that can be used in our main.tf configuration file

variable "rgname" {
  type = string
  description = "used to define resource group name"
}

variable "rglocation" {
  type = string
  description = "used to define resource group location"
  default = "East US"
}

variable "prefix" {
  type = string
  description = "used to define a standard prefix for all resources"
}

variable "vnet_cidr_prefix" {
  type = string
  description = "used to define address space for VNET"
}

variable "subnet_cidr_prefix" {
  type = string
  description = "used to define address space for subnet VNET"
}

variable "subnet" {
  type = string
  description = "used to define subnet name"
}
