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

module "storage_account" {
  source = "../../modules/storage_account"

  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  name_prefix         = var.name_prefix
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
  secret_env_vars         = merge(var.secret_env_vars, {
    KARMA_STORAGE_CONNECTION_STRING = module.storage_account.primary_connection_string
  })
  log_retention_days      = var.log_retention_days
  tags                    = var.tags
}

module "feature_ideator_job" {
  source = "../../modules/container_app_job"

  resource_group_name          = azurerm_resource_group.main.name
  location                     = var.location
  name_prefix                  = var.name_prefix
  job_name                     = "feature-ideator"
  image                        = var.jobs_image
  container_app_environment_id = module.container_app.container_app_environment_id
  pull_identity_id             = module.container_registry.pull_identity_id
  registry_login_server        = module.container_registry.login_server
  cron_expression              = "0 9 * * 1"
  cpu                          = 0.5
  memory                       = "1Gi"
  env_vars = {
    DISCORD_GUILD_ID = "427309774669873152"
    DAYS_BACK        = "7"
    GITHUB_REPO      = "skarumbu/discord-bot-app"
  }
  secret_env_vars = var.jobs_secret_env_vars
  tags            = var.tags
}
