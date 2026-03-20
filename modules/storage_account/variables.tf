variable "resource_group_name" {
  type        = string
  description = "Name of the Azure resource group"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "name_prefix" {
  type        = string
  description = "Prefix used to name the storage account (hyphens are stripped; 'karma' is appended)"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources in this module"
  default     = {}
}
