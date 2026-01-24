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

# UAI - CI/CD
resource "azurerm_user_assigned_identity" "ci_cd_uai" {
  name                = var.uai_ci_cd_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# RBAC - AKS Pull ACR Container
resource "azurerm_role_assignment" "rbac_aks_acr_pull" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = var.aks_uai_principal_id
}

# RBAC - CI/CD 
resource "azurerm_role_assignment" "rbac_ci_cd_acr" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPush"
  principal_id         = azurerm_user_assigned_identity.ci_cd_uai.principal_id
}