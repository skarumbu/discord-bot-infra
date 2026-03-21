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
  description = "Prefix used to name the job resource: {name_prefix}-{job_name}"
}

variable "job_name" {
  type        = string
  description = "Short name for the job (e.g. 'feature-ideator'). Combined with name_prefix for the resource name."
}

variable "image" {
  type        = string
  description = "Full container image reference (e.g. myacr.azurecr.io/discord-bot-jobs:sha-abc1234)"
  default     = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}

variable "container_app_environment_id" {
  type        = string
  description = "Resource ID of the Container App Environment to run the job in"
}

variable "pull_identity_id" {
  type        = string
  description = "Resource ID of the user-assigned managed identity with AcrPull role"
}

variable "registry_login_server" {
  type        = string
  description = "ACR login server URL (e.g. myacr.azurecr.io)"
}

variable "cron_expression" {
  type        = string
  description = "CRON expression for the schedule trigger (UTC)"
  default     = "0 9 * * 1" # Every Monday 9am UTC
}

variable "cpu" {
  type        = number
  description = "CPU cores allocated to each job replica"
  default     = 0.5
}

variable "memory" {
  type        = string
  description = "Memory allocated to each job replica (e.g. '1Gi')"
  default     = "1Gi"
}

variable "env_vars" {
  type        = map(string)
  description = "Non-sensitive environment variables"
  default     = {}
}

variable "secret_env_vars" {
  type        = map(string)
  sensitive   = true
  description = "Sensitive environment variables — stored as Container App Job secrets and injected at runtime"
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources in this module"
  default     = {}
}
