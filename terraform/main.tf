# Configurar Azure como provider para crear la infraestructura
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

terraform {
  required_providers {
     azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.22.0"
    }
  }
}

# indicar aquí el subscription_id o en una variable de entorno
provider "azurerm" {
  features {}
}
