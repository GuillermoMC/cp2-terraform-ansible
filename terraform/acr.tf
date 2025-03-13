# Configuración del ACR
resource "azurerm_container_registry" "acr" {
  name                = "containerRegistryCP2"
  resource_group_name = azurerm_resource_group.rgcp2.name
  location            = azurerm_resource_group.rgcp2.location
  sku                 = "Standard"
  admin_enabled       = true
}