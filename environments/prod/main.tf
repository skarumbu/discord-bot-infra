terraform {
  required_version = ">= 1.7.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.110"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "main" {
  name     = "${var.name_prefix}-rg"
  location = var.location
  tags     = var.tags
}

# Swap this source line for an AWS/GCP equivalent without changing the interface
module "container_registry" {
  source = "../../modules/container_registry"

  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  name_prefix         = var.name_prefix
  sku                 = var.acr_sku
  tags                = var.tags
}

# Swap this source line for an AWS/GCP equivalent without changing the interface
module "container_app" {
  source = "../../modules/container_app"

  resource_group_name     = azurerm_resource_group.main.name
  location                = var.location
  name_prefix             = var.name_prefix
  app_name                = var.app_name
  image                   = var.image
  pull_identity_id        = module.container_registry.pull_identity_id
  pull_identity_client_id = module.container_registry.pull_identity_client_id
  registry_login_server   = module.container_registry.login_server
  cpu                     = var.cpu
  memory                  = var.memory
  min_replicas            = var.min_replicas
  max_replicas            = var.max_replicas
  env_vars                = var.env_vars
  secret_env_vars         = var.secret_env_vars
  log_retention_days      = var.log_retention_days
  tags                    = var.tags
}
