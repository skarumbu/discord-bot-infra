# Remote state stored in Azure Blob Storage.
# The storage account must be created manually before running `terraform init`.
#
# Example (run once):
#   az group create -n tfstate-rg -l eastus
#   az storage account create -n <sa_name> -g tfstate-rg -l eastus --sku Standard_LRS
#   az storage container create -n tfstate --account-name <sa_name>
#
# Then set ARM_ACCESS_KEY (or use az login) and run `terraform init`.

terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "discordbottfstate" # change to your storage account name
    container_name       = "tfstate"
    key                  = "discord-bot-infra/dev/terraform.tfstate"
  }
}
