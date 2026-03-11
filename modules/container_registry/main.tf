resource "azurerm_container_registry" "main" {
  name                = "${var.name_prefix}acr"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = false # Use Managed Identity (AcrPull) — no static secrets

  tags = var.tags
}

resource "azurerm_user_assigned_identity" "acr_pull" {
  name                = "${var.name_prefix}-acr-pull"
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = var.tags
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.acr_pull.principal_id
}
