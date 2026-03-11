variable "resource_group_name" {
  type        = string
  description = "Name of the Azure resource group"
}

variable "location" {
  type        = string
  description = "Azure region (e.g. eastus, westeurope)"
}

variable "name_prefix" {
  type        = string
  description = "Lowercase alphanumeric prefix used to name the ACR and related resources. ACR names must be globally unique and 5-50 chars."
  validation {
    condition     = can(regex("^[a-z0-9]+$", var.name_prefix))
    error_message = "name_prefix must contain only lowercase letters and numbers (ACR constraint)."
  }
}

variable "sku" {
  type        = string
  description = "ACR pricing tier: Basic, Standard, or Premium"
  default     = "Basic"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "sku must be one of: Basic, Standard, Premium."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources in this module"
  default     = {}
}
