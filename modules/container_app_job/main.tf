resource "azurerm_container_app_job" "main" {
  name                         = "${var.name_prefix}-${var.job_name}"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  container_app_environment_id = var.container_app_environment_id
  replica_timeout_in_seconds   = 3600 # 1 hour — enough for Claude Code to implement and test

  schedule_trigger_config {
    cron_expression          = var.cron_expression
    parallelism              = 1
    replica_completion_count = 1
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.pull_identity_id]
  }

  registry {
    server   = var.registry_login_server
    identity = var.pull_identity_id
  }

  dynamic "secret" {
    for_each = var.secret_env_vars
    content {
      name  = lower(replace(secret.key, "_", "-"))
      value = secret.value
    }
  }

  template {
    container {
      name   = var.job_name
      image  = var.image
      cpu    = var.cpu
      memory = var.memory

      dynamic "env" {
        for_each = var.env_vars
        content {
          name  = env.key
          value = env.value
        }
      }

      dynamic "env" {
        for_each = var.secret_env_vars
        content {
          name        = env.key
          secret_name = lower(replace(env.key, "_", "-"))
        }
      }
    }
  }

  tags = var.tags
}
