output "login_server" {
  value       = azurerm_container_registry.main.login_server
  description = "ACR login server URL (e.g. myacr.azurecr.io)"
}

output "registry_name" {
  value       = azurerm_container_registry.main.name
  description = "ACR resource name"
}

output "registry_id" {
  value       = azurerm_container_registry.main.id
  description = "ACR resource ID"
}

output "pull_identity_id" {
  value       = azurerm_user_assigned_identity.acr_pull.id
  description = "Resource ID of the AcrPull user-assigned managed identity"
}

output "pull_identity_client_id" {
  value       = azurerm_user_assigned_identity.acr_pull.client_id
  description = "Client ID of the AcrPull managed identity (used in Container App registry config)"
}

output "pull_identity_principal_id" {
  value       = azurerm_user_assigned_identity.acr_pull.principal_id
  description = "Principal ID of the AcrPull managed identity"
}
