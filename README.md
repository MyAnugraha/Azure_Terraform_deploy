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

##### 8. Data Sources:
If you want to deploy a new azure resource using terraform with existing resource available which is not created using actual terraform code.
Using "data" component we can define a existing resource.
Ex: if you have resource group in azure which is not created with terraform code, I want to tell terraform that there is existing rg in azure portal.
for that we are using "data" component

data "azurerm_resource_group" "rg" {

name = "exising rg name"

location = "existing rg location"

}

Note: If you destroy the deployment, it will delete the new resources created but will not delete the existing resources we defined to terraform.

##### 9. Locals or Local Values:
To make our code simple we use locals concept. It reduces the complexity in the code. 
   
data "azurerm_resource_group" "rg1" {

  name     = "NextOpsVideos"
  
}

locals {

  rg_info = data.azurerm_resource_group.rg1
  
}

##### 10. Import: What is Terraform Import? How to import existing resources into statefile
terraform import command will import the existing resource to statefile.
Here we need to define the existing resource details in Visual studio and then run the terraform import.

terraform import azurerm_resource_group.existing_rg "resourceID of the the rg of existing azure resource" 

What is difference between Data sources and Import?
With data sources we are using existing resources details to create more resources using terraform. 
So clearly we are not adding existing resources to our statefile.
Whereas, Import is adding the existing resources to our statefile.

##### 11. Terraform Functions: This helps to simplify the code. 
Function is nothing but reusable code. If someone defined a function, we need not to write that code language again.
We can reuse that function. 
Ex: If there is calculator is program, division, multiply, addition, substraction are functions.
Likewise there are built-in functions in terraform.
