output "job_name" {
  value       = azurerm_container_app_job.main.name
  description = "Name of the Container App Job resource"
}

output "job_id" {
  value       = azurerm_container_app_job.main.id
  description = "Resource ID of the Container App Job"
}
