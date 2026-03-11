# Remote state stored in Azure Blob Storage — isolated from dev state.
# The storage account must be created manually before running `terraform init`.
# Use the same storage account as dev but a separate state key.
#
# Then set ARM_ACCESS_KEY (or use az login) and run `terraform init`.

terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "discordbottfstate" # change to your storage account name
    container_name       = "tfstate"
    key                  = "discord-bot-infra/prod/terraform.tfstate"
  }
}
