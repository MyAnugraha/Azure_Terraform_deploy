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

