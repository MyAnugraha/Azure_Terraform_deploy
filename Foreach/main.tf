# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  subscription_id    = "90971351-75aa-4891-9e97-856804f03ada"
  client_id          = "f8518918-e301-4003-8537-b4661cca9727"
  client_secret      = "XmE8Q~hXVXed2RZJW-rbFO9qkAOxv9qExGi2Uabk1"
  tenant_id          = "e57b82e9-8c2f-423b-b7ee-cff111bc131a"

}

resource "azurerm_resource_group" "myrg" {
  for_each = var.resourcedetails

  name     = each.value.rg_name
  location = each.value.location
}

resource "azurerm_virtual_network" "myvnet" {
  for_each            = var.resourcedetails
  name                = each.value.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg[each.key].location
  resource_group_name = azurerm_resource_group.myrg[each.key].name
}

resource "azurerm_subnet" "mysubnet" {
  for_each = var.resourcedetails

  name                 = each.value.subnet_name
  address_prefixes     = ["10.0.0.0/24"]
  virtual_network_name = azurerm_virtual_network.myvnet[each.key].name
  resource_group_name  = azurerm_resource_group.myrg[each.key].name
}

resource "azurerm_network_interface" "mynic" {
  for_each            = var.resourcedetails
  name                = "my-nic"  
  location            = azurerm_resource_group.myrg[each.key].location
  resource_group_name = azurerm_resource_group.myrg[each.key].name
  ip_configuration {
    name                          = "my-ip-config"
    subnet_id                     = azurerm_subnet.mysubnet[each.key].id
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_virtual_machine" "vm" {
  for_each              = var.resourcedetails
  name                  = each.value.name
  location              = azurerm_resource_group.myrg[each.key].location
  resource_group_name   = azurerm_resource_group.myrg[each.key].name
  network_interface_ids = [azurerm_network_interface.mynic[each.key].id]
  vm_size               = each.value.size

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${each.value.name}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = each.value.name
    admin_username = "adminuser"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  
}
