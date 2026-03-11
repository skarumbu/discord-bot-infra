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
  description = "Prefix used to name the Log Analytics Workspace and Container App Environment"
}

variable "app_name" {
  type        = string
  description = "Name of the Container App resource (also used as the container name)"
}

variable "image" {
  type        = string
  description = "Full container image reference (e.g. myacr.azurecr.io/discord-bot:v1)"
}

variable "pull_identity_id" {
  type        = string
  description = "Resource ID of the user-assigned managed identity with AcrPull role"
}

variable "pull_identity_client_id" {
  type        = string
  description = "Client ID of the AcrPull managed identity (required by Container App registry block)"
}

variable "registry_login_server" {
  type        = string
  description = "ACR login server URL (e.g. myacr.azurecr.io)"
}

variable "cpu" {
  type        = number
  description = "CPU cores allocated to the container (0.25, 0.5, 0.75, 1.0, ...)"
  default     = 0.25
}

variable "memory" {
  type        = string
  description = "Memory allocated to the container (e.g. '0.5Gi', '1Gi')"
  default     = "0.5Gi"
}

variable "min_replicas" {
  type        = number
  description = "Minimum number of replicas. Set to 1 — Discord bots need a persistent WebSocket connection; scale-to-zero drops it."
  default     = 1
}

variable "max_replicas" {
  type        = number
  description = "Maximum number of replicas. Keep at 1 — multiple replicas cause duplicate Discord event processing without sharding."
  default     = 1
}

variable "env_vars" {
  type        = map(string)
  description = "Non-sensitive environment variables to pass to the container"
  default     = {}
}

variable "secret_env_vars" {
  type        = map(string)
  sensitive   = true
  description = "Sensitive environment variables (e.g. DISCORD_TOKEN). Stored as Container App secrets and injected at runtime."
  default     = {}
}

variable "log_retention_days" {
  type        = number
  description = "Log Analytics Workspace retention period in days (30-730)"
  default     = 30
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources in this module"
  default     = {}
}
