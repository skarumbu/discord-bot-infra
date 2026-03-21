output "resource_group_name" {
  value       = azurerm_resource_group.main.name
  description = "Resource group containing all prod resources"
}

output "acr_login_server" {
  value       = module.container_registry.login_server
  description = "ACR login server — use with `az acr login --name` and `docker push`"
}

output "acr_name" {
  value       = module.container_registry.registry_name
  description = "ACR resource name"
}

output "container_app_name" {
  value       = module.container_app.container_app_name
  description = "Container App resource name"
}

output "container_app_id" {
  value       = module.container_app.container_app_id
  description = "Container App resource ID"
}

output "feature_ideator_job_name" {
  value       = module.feature_ideator_job.job_name
  description = "Name of the Feature Ideator Container App Job"
}

output "first_deploy_sequence" {
  value = <<-EOT
    First-deploy steps:
    1. Create Blob Storage account for Terraform state (see backend.tf for commands)
    2. terraform init && terraform apply          # deploys placeholder image
    3. az acr login --name ${module.container_registry.registry_name}
    4. docker build -t ${module.container_registry.login_server}/discord-bot:<tag> .
       docker push ${module.container_registry.login_server}/discord-bot:<tag>
    5. terraform apply -var='image=${module.container_registry.login_server}/discord-bot:<tag>'
  EOT
  description = "Step-by-step guide for the initial deployment"
}
