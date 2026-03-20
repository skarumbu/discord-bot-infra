resource "azurerm_storage_account" "main" {
  name                     = "${replace(var.name_prefix, "-", "")}karma"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

resource "azurerm_storage_table" "karma" {
  name                 = "karma"
  storage_account_name = azurerm_storage_account.main.name
}
