variable "subscription_id" {
  type        = string
  description = "Azure subscription ID. Pass via TF_VAR_subscription_id — do not put in terraform.tfvars."
  sensitive   = true
}

variable "location" {
  type        = string
  description = "Azure region for all resources"
}

variable "name_prefix" {
  type        = string
  description = "Lowercase alphanumeric prefix for resource names (must satisfy ACR naming constraint)"
  validation {
    condition     = can(regex("^[a-z0-9]+$", var.name_prefix))
    error_message = "name_prefix must contain only lowercase letters and numbers."
  }
}

variable "app_name" {
  type        = string
  description = "Name of the Container App"
}

variable "image" {
  type        = string
  description = "Container image to deploy. Defaults to a placeholder image for first deploy; update after pushing to ACR."
  default     = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}

variable "acr_sku" {
  type        = string
  description = "ACR SKU (Standard for prod — enables geo-replication and content trust)"
  default     = "Standard"
}

variable "cpu" {
  type    = number
  default = 0.5
}

variable "memory" {
  type    = string
  default = "1Gi"
}

variable "min_replicas" {
  type    = number
  default = 1
}

variable "max_replicas" {
  type    = number
  default = 1
}

variable "env_vars" {
  type        = map(string)
  description = "Non-sensitive environment variables"
  default     = {}
}

variable "secret_env_vars" {
  type        = map(string)
  sensitive   = true
  description = "Sensitive environment variables (e.g. DISCORD_TOKEN). Pass via TF_VAR_secret_env_vars."
  default     = {}
}

variable "log_retention_days" {
  type    = number
  default = 90
}

variable "tags" {
  type    = map(string)
  default = {}
}
