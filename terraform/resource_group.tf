# Crea un grupo de recursos
resource "azurerm_resource_group" "rgcp2" {
  name     = var.resource_group_name_prefix
  location = var.resource_group_location
}