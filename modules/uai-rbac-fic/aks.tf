# AKS -  UAI, RBAC & FIC - modules\aks\

# UAI- AKS
resource "azurerm_user_assigned_identity" "uai_aks" {
  name                = var.uai_aks_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# RBAC - AKS ACR Pull
resource "azurerm_role_assignment" "rbac_aks_acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.uai_aks.principal_id
}

# RBAC - AKS Network 
resource "azurerm_role_assignment" "rbac_aks_network" {
  scope                = var.aks_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.uai_aks.principal_id
}

resource "azurerm_role_assignment" "rbac_aks_disk_encryption" {
  scope                = var.disk_encryption_set_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.uai_aks.principal_id
}
