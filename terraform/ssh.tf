# https://learn.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-terraform?tabs=azure-cli

resource "random_pet" "ssh_key_name" {
  prefix    = "ssh"
  separator = ""
}

resource "azapi_resource_action" "ssh_public_key_gen" {
  type        = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  resource_id = azapi_resource.ssh_public_key.id
  action      = "generateKeyPair"
  method      = "POST"

  response_export_values = ["publicKey", "privateKey"]
}

resource "azapi_resource" "ssh_public_key" {
  type      = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  name      = random_pet.ssh_key_name.id
  location  = azurerm_resource_group.rgcp2.location
  parent_id = azurerm_resource_group.rgcp2.id
}

# Output de la clave privada (no se muestra por pantalla)
output "private_key" {
  value     = azapi_resource_action.ssh_public_key_gen.output.privateKey
  sensitive = true
}

# Output de la clave publica
output "public_key" {
  value = azapi_resource_action.ssh_public_key_gen.output.publicKey
}