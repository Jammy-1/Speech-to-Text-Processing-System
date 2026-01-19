# ACR
resource "azurerm_container_registry" "main" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  sku                           = "Premium"
  admin_enabled                 = false
  public_network_access_enabled = false

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.acr_uai.id]
  }

  encryption {
    key_vault_key_id   = var.key_vault_id
    identity_client_id = azurerm_user_assigned_identity.acr_uai.client_id
  }
}

# UAI - ACR
resource "azurerm_user_assigned_identity" "acr_uai" {
  name                = var.uai_acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# RBAC - AKS-ACR
resource "azurerm_role_assignment" "rbac_aks_acr_pull" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = var.aks_uai_principal_id
}