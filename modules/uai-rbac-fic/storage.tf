# UAI & RBAC For Storage

# Kubernetes - modules\storage\storage_account.tf

# UAI - K8 -  Storage Worker
resource "azurerm_user_assigned_identity" "storage_worker_uai" {
  name                = var.uai_storage_worker_name
  resource_group_name = var.resource_group_name
  location            = var.location
}

# RBAC - K8 -  Storage Worker -  Audio Container  
resource "azurerm_role_assignment" "rbac_storage_worker_audio_container" {
  scope                = var.audio_container_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.storage_worker_uai.principal_id
}

# RBAC - K8 - Storage Worker - Transcripts Container  
resource "azurerm_role_assignment" "rbac_storage_worker_transcripts_container" {
  scope                = var.transcripts_container_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.storage_worker_uai.principal_id
}

# FIC - Storage Worker 
resource "azurerm_federated_identity_credential" "storage_worker_fic" {
  name                = "storage-worker-fic"
  resource_group_name = var.resource_group_name
  parent_id           = azurerm_user_assigned_identity.storage_worker_uai.id
  issuer              = var.aks_oidc
  subject             = "system:serviceaccount:storage-stt:storage-worker-sa"
  audience            = ["api://AzureADTokenExchange"]

  depends_on = [azurerm_user_assigned_identity.storage_worker_uai]
}