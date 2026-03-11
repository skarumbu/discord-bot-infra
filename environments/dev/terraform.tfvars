# Non-secret values only.
# Secrets are passed via environment variables:
#   export TF_VAR_subscription_id="<your-subscription-id>"
#   export TF_VAR_secret_env_vars='{"DISCORD_TOKEN":"<your-token>"}'

location    = "eastus"
name_prefix = "discordbotdev"
app_name    = "discord-bot-dev"
acr_sku     = "Basic"

cpu                = 0.25
memory             = "0.5Gi"
min_replicas       = 1
max_replicas       = 1
log_retention_days = 30

# image defaults to placeholder; override after first ACR push:
#   terraform apply -var='image=discordbotdevacr.azurecr.io/discord-bot:v1'

env_vars = {
  # Add non-sensitive bot config here, e.g.:
  # LOG_LEVEL = "debug"
}

tags = {
  environment = "dev"
  project     = "discord-bot"
  managed_by  = "terraform"
}
