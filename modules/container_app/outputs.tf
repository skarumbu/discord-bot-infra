output "container_app_id" {
  value       = azurerm_container_app.main.id
  description = "Resource ID of the Container App"
}

output "container_app_name" {
  value       = azurerm_container_app.main.name
  description = "Name of the Container App"
}

output "fqdn" {
  value       = null
  description = "Always null — ingress is disabled. Discord bots use outbound WebSocket only; no inbound endpoint is exposed."
}

output "container_app_environment_id" {
  value       = azurerm_container_app_environment.main.id
  description = "Resource ID of the Container App Environment"
}

output "log_analytics_workspace_id" {
  value       = azurerm_log_analytics_workspace.main.id
  description = "Resource ID of the Log Analytics Workspace"
}
