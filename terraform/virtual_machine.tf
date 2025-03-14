# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine
# https://learn.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-terraform?tabs=azure-cli

# Crear la red virtual
resource "azurerm_virtual_network" "vNetwork" {
  name                = "cp2VN"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rgcp2.location
  resource_group_name = azurerm_resource_group.rgcp2.name
}

# Crear la subnet
resource "azurerm_subnet" "vSubnet" {
  name                 = "cp2Subnet"
  resource_group_name  = azurerm_resource_group.rgcp2.name
  virtual_network_name = azurerm_virtual_network.vNetwork.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Crear una IP publica
resource "azurerm_public_ip" "ipPublica" {
  name                = "cp2PublicIp"
  location            = azurerm_resource_group.rgcp2.location
  resource_group_name = azurerm_resource_group.rgcp2.name
  //allocation_method   = "Dynamic"
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Crear reglas y grupo de seguridad
resource "azurerm_network_security_group" "ssh" {
  name                = "cp2SecurityGroupSSH"
  location            = azurerm_resource_group.rgcp2.location
  resource_group_name = azurerm_resource_group.rgcp2.name

  // Crear regla para permitir ssh
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  // Crear regla para permitir ssh
  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Crear la interfaz de red
resource "azurerm_network_interface" "nic" {
  name                = "cp2NIC"
  location            = azurerm_resource_group.rgcp2.location
  resource_group_name = azurerm_resource_group.rgcp2.name

  ip_configuration {
    name                          = "cp2IpConfiguration"
    subnet_id                     = azurerm_subnet.vSubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ipPublica.id
  }
}

# Conexión entre la interfaz de red creada previamente y el grupo de seguridad
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.ssh.id
}


# Creación de la maquina virtual con OS Ubuntu24
resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  name                  = "cp2VM-Ubuntu24"
  location              = azurerm_resource_group.rgcp2.location
  resource_group_name   = azurerm_resource_group.rgcp2.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = "Standard_F2s_v2"

  os_disk {
    name                 = "cp2VM-DISK"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "hostname"
  admin_username = var.username

  admin_ssh_key {
    username   = var.username
    public_key = azapi_resource_action.ssh_public_key_gen.output.publicKey
  }

}
