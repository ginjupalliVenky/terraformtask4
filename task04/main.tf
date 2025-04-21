data "azurerm_resource_group" "existing" {
  name = var.rg_name
}

resource "azurerm_resource_group" "this" {
  name     = var.rg_name
  location = data.azurerm_resource_group.existing.location

  tags = {
    Creator = var.creator
  }
}

resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = { Creator = var.creator }
}

resource "azurerm_subnet" "this" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "this" {
  name                = var.public_ip_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  domain_name_label   = var.domain_name_label
  tags                = { Creator = var.creator }
}

resource "azurerm_network_security_group" "this" {
  name                = var.nsg_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = { Creator = var.creator }
}

resource "azurerm_network_security_rule" "allow_http" {
  name                        = var.nsg_rule_http
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefixes     = [var.my_ip, var.verification_ip]
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = var.nsg_rule_ssh
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes     = [var.my_ip, var.verification_ip]
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_network_interface" "this" {
  name                = var.nic_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = var.ip_config_name
    subnet_id                     = azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.this.id
  }

  tags = { Creator = var.creator }
}

resource "azurerm_network_interface_security_group_association" "this" {
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_linux_virtual_machine" "this" {
  name                            = var.vm_name
  resource_group_name             = azurerm_resource_group.this.name
  location                        = azurerm_resource_group.this.location
  size                            = var.vm_sku
  admin_username                  = var.vm_username
  admin_password                  = var.vm_password
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.this.id]

  os_disk {
    name                 = "${var.vm_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name = var.vm_name
  tags          = { Creator = var.creator }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]

    connection {
      type     = "ssh"
      user     = var.vm_username
      password = var.vm_password
      host     = azurerm_public_ip.this.ip_address
    }
  }
}