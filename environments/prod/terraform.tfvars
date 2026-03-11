# Non-secret values only.
# Secrets are passed via environment variables:
#   export TF_VAR_subscription_id="<your-subscription-id>"
#   export TF_VAR_secret_env_vars='{"DISCORD_TOKEN":"<your-prod-token>"}'

location    = "eastus"
name_prefix = "discordbotprod"
app_name    = "discord-bot-prod"
acr_sku     = "Standard"

cpu                = 0.5
memory             = "1Gi"
min_replicas       = 1
max_replicas       = 1
log_retention_days = 90

# image defaults to placeholder; override after first ACR push:
#   terraform apply -var='image=discordbotprodacr.azurecr.io/discord-bot:v1'

env_vars = {
  # Add non-sensitive bot config here, e.g.:
  # LOG_LEVEL = "info"
}

tags = {
  environment = "prod"
  project     = "discord-bot"
  managed_by  = "terraform"
}
