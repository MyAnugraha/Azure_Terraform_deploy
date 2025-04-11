##### Azure_Terraform_deploy:
##### Components (Integral part of Terraform) of Terraform
##### 1. Providers
##### 2. Resources
##### 3. Variables
##### 4. Statefile
##### 5. Provisioners
##### 6. Backends
##### 7. Modules
##### 8. Data Sources
##### 9. Service Principals

##### 1. Providers :
Providers is nothing but, terraform will interact with cloud providers using providers plugin.
Provider is an interaction between terraform application and the respective infra service.
Simply, It's an interactive component for any cloud service providers.

##### terraform {

  ##### required_providers {
  
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  
}

provider "azurerm" {

  features {}


  subscription_id    = "__"
  
  client_id          = "__"
  
  client_secret      = "__"
  
  tenant_id          = "__"


}


##### 2. Resources:
Resource is an component to build infrastructure objects like, vnets, subnets, vm's etc.

##### resource "azurerm_resource_group" "rg" {

##### name     = "****"

##### location = "****"
  
}

##### 3. Variables:
Using variables in terraform configurations makes our deployments more dynamic.
We create variable.tf file to store variables and that can be used in our main.tf configuration file

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

