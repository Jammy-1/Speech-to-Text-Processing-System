# Kubernetes API  - modules\kubernetes\api.tf

# UAI - API UAI - API Worker
resource "azurerm_user_assigned_identity" "api_uai" {
  name                = var.uai_api_worker_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# RBAC - API Service Bus Sender
resource "azurerm_role_assignment" "rbac_api_sb_sender" {
  scope                = var.service_bus_namespace_id
  role_definition_name = "Azure Service Bus Data Sender"
  principal_id         = azurerm_user_assigned_identity.api_uai.principal_id
}

# FIC - API
resource "azurerm_federated_identity_credential" "api_fic" {
  name      = "api-fic"
  parent_id = azurerm_user_assigned_identity.api_uai.id
  issuer    = var.aks_oidc
  subject   = "system:serviceaccount:api-stt:api-sa"
  audience  = ["api://AzureADTokenExchange"]

  depends_on = [azurerm_user_assigned_identity.api_uai]
}
