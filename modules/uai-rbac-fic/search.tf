# UAI & RBAC For Search - modules\cognitive\search.tf

# UAI - Search Service
resource "azurerm_user_assigned_identity" "search_service_uai" {
  name                = var.uai_search_service_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

data "azurerm_client_config" "current" {}

# Role Definition- Search Index
data "azurerm_role_definition" "rdef_search_index_data_contributor" {
  name  = "Search Index Data Contributor"
  scope = var.search_service_id
}

# RBAC - Search Index - Pipeline
resource "azurerm_role_assignment" "rbac_search_index_contributor" {
  scope              = var.search_service_id
  role_definition_id = data.azurerm_role_definition.rdef_search_index_data_contributor.id
  principal_id       = data.azurerm_client_config.current.object_id
}

# Kubernetes - modules\kubernetes\search.tf

# UAI - Used On K8 Search Worker
resource "azurerm_user_assigned_identity" "search_worker_uai" {
  name                = var.uai_search_worker_name
  resource_group_name = var.resource_group_name
  location            = var.location
}

# RBAC - Storage Reader - Transcripts - K8 Search Worker 
resource "azurerm_role_assignment" "rbac_search_worker_storage_reader" {
  scope                = var.transcripts_container_id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_user_assigned_identity.search_worker_uai.principal_id
}

# RBAC - Key Vault Search Key Access - K8 Search Worker 
resource "azurerm_role_assignment" "rbac_search_worker_kv_access" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.search_worker_uai.principal_id
}

# FIC - Search Worker
resource "azurerm_federated_identity_credential" "search_worker_fic" {
  name                = "search-worker-fic"
  resource_group_name = var.resource_group_name
  parent_id           = azurerm_user_assigned_identity.search_worker_uai.id
  issuer              = var.aks_oidc
  subject             = "system:serviceaccount:search-stt:search-worker-sa"
  audience            = ["api://AzureADTokenExchange"]

  depends_on = [azurerm_user_assigned_identity.search_worker_uai]
}




