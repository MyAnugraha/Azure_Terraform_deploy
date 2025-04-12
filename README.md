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

##### 4. Statefile:
Whenever the deployment is finished, terraform creates statefile automatically to keep the track of current state of the infrastructure.
Which means statefile will have the records of the infrastructure created using terraform. 
Whenever you want to deploy/destroy the resources, terraform will compare with current statefile.
A file with a name of terraform.tfstate will be created automatically in our working directory.

##### 5. Provisioners:
Similar to configuration management tools. Like sheff, ansible, puppet functionalities will be there in provisioners.
Once we build the infra if you want to run some configurations, we will use provisioners.

provisioner "file" {

source = "./script.ps1"

destination = "C:/temp/setup.ps1"

Connection {

type = "winrm"

user = "Admin"

password = "Welcome123"

host = "server1"

}

}

##### 6. Backends:
We call it as Terraform Backends or Remote statefile.
In realtime scenarios, we save the statefile in central location like NFS Share, azure cloud storage, AWS cloud storage.
We recommend to store the statefiles in shared cloud storages. 
For that, we need to have a storage account and container.

Most importantly, we need to pass authentication mechanism to terraform.

terraform {

  backend "azurerm" {
  
    access_key           = "abcdefghijklmnopqrstuvwxyz0123456789..."
    
    storage_account_name = "abcd1234"
    
    container_name       = "tfstate"
    
    key                  = "prod.terraform.tfstate"
    
  }
  
}

Accesskey will be available in our container.

##### 7. Modules:
We can create multiple environments in a very easy way.
Using Modules component we can pass the key vaules to our main deployment.

module "module_dev" {

    source = "./modules"
    
    prefix = "dev"
    
    vnet_cidr_prefix = "10.20.0.0/16"
    
    subnet1_cidr_prefix = "10.20.1.0/24"
    
    rgname = "DevRG" 
    
    subnet = "DevSubnet"  
    
}

If I want to modify/destroy specific environment, you can use target component.
Ex: terraform destroy --target=module.module_prod


