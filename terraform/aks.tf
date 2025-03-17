# Crear un cluster de kubernetes (AKS)
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "cp2aks"
  location            = azurerm_resource_group.rgcp2.location
  resource_group_name = azurerm_resource_group.rgcp2.name
  dns_prefix          = "cp2aks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Development"
  }

}

# Definiir permisos de descarga desde el ACR
resource "azurerm_role_assignment" "ra" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}