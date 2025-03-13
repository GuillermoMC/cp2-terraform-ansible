variable "resource_group_location" {
  type        = string
  default     = "West Europe"
  description = "Localización del recurso"
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "rg-cp2rg"
  description = "Nombre del recurso"
}

variable "username" {
  type        = string
  description = "El usuario para la maquina virtual"
  default     = "azureadmin"
}