# discord-bot-infra

Terraform infrastructure for the Discord bot. Provisions and manages Azure resources for the production environment.

Bot source code lives in [`discord-bot-app`](https://github.com/skarumbu/discord-bot-app). Pushing to `main` there automatically builds the image, pushes it to ACR, and runs `terraform apply` — no manual deploy steps needed.

## Resources

- **Azure Container Registry** — stores Docker images built from `discord-bot-app`
- **Azure Container App** — runs the bot container
- **Log Analytics Workspace** — container logs

## Structure

```
environments/
  dev/    # dev bot (Basic ACR, smaller compute)
  prod/   # prod bot (Standard ACR)
modules/
  container_registry/
  container_app/
```

## First-Time Setup

Before CI can deploy, infrastructure must exist. Run once manually:

```bash
# 1. Create Terraform state storage (if it doesn't exist)
az group create -n tfstate-rg -l eastus
az storage account create -n discordbottfstate -g tfstate-rg -l eastus --sku Standard_LRS
az storage container create -n tfstate --account-name discordbottfstate

# 2. Set required env vars
export TF_VAR_subscription_id="<your-subscription-id>"
export TF_VAR_secret_env_vars='{"DISCORD_TOKEN":"<your-prod-token>"}'

# 3. Init and apply (deploys with placeholder image)
cd environments/prod
terraform init
terraform apply
```

After this, push any commit to `discord-bot-app/main` — CI handles all subsequent deploys.

## Manual Apply

For infrastructure-only changes (not image updates), apply directly:

```bash
export TF_VAR_subscription_id="<your-subscription-id>"
export TF_VAR_secret_env_vars='{"DISCORD_TOKEN":"<your-prod-token>"}'
cd environments/prod
terraform apply
```

To pin a specific image without pushing app code:

```bash
terraform apply -var='image=discordbotprodacr.azurecr.io/discord-bot:sha-abc1234'
```

## CI/CD GitHub Secrets

The following secrets must be set in `discord-bot-app` for the deploy workflow to function:

| Secret | Description |
|--------|-------------|
| `AZURE_CLIENT_ID` | App registration client ID (OIDC) |
| `AZURE_TENANT_ID` | Azure tenant ID |
| `AZURE_SUBSCRIPTION_ID` | Azure subscription ID |
| `TF_VAR_SECRET_ENV_VARS` | `{"DISCORD_TOKEN":"..."}` |
| `INFRA_REPO_PAT` | Fine-grained PAT with read access to this repo |

The app registration needs: `AcrPush` on the ACR, `Contributor` on the prod resource group, and `Storage Blob Data Contributor` on the `discordbottfstate` storage account.
