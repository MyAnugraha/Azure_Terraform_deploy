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

# Configure the Resource Group called MyAnugraha
resource "azurerm_resource_group" "rg" {
  name     = "MyAnugraha"
  location = "East US"
}

# locals are used to make our script easy when we have multiple resources by making them with local shortcut

locals {
  rg_info = resource.azurerm_resource_group.rg
}

# Configure Virtual Network called AnugrahaVNET
resource "azurerm_virtual_network" "vnet" {
  name                = "AnugrahaVNET"
  location            = local.rg_info.location
  resource_group_name = local.rg_info.name
  address_space       = ["10.10.0.0/16"]

}

#Configure Subnet for above VNET

resource "azurerm_subnet" "subnet" {
  name                 = "subnet"
  resource_group_name  = local.rg_info.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.1.0/24"]

}

resource "azurerm_network_security_group" "nsg" {
  name                = "Anugraha-nsg"
  resource_group_name = "${local.rg_info.name}"
  location            = "${local.rg_info.location}"
}

# NOTE: this allows RDP from any network
resource "azurerm_network_security_rule" "rdp" {
  name                        = "rdp"
  resource_group_name         = "${local.rg_info.name}"
  network_security_group_name = "${azurerm_network_security_group.nsg.name}"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_subnet_network_security_group_association" "nsg_subnet_assoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_interface" "nic" {
  name                = "AnugrahaVM-nic"
  resource_group_name = local.rg_info.name
  location            = local.rg_info.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "main" {
  name                            = "AnugrahaVM"
  resource_group_name             = local.rg_info.name
  location                        = local.rg_info.location
  size                            = "Standard_B1s"
  admin_username                  = "adminuser"
  admin_password                  = "P@ssw0rd1234!"
  network_interface_ids = [ azurerm_network_interface.nic.id ]

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}
