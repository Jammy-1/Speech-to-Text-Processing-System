# UAI & RBAC For Storage

# Kubernetes - modules\storage\storage_account.tf & modules\kubernetes\storage.tf

# UAI - Storage Worker
resource "azurerm_user_assigned_identity" "storage_worker_uai" {
  name                = var.uai_storage_worker_name
  resource_group_name = var.resource_group_name
  location            = var.location
}

# RBAC - Storage Worker -  Audio Container  
resource "azurerm_role_assignment" "rbac_storage_worker_audio_container" {
  scope                = var.audio_container_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.storage_worker_uai.principal_id
}

# RBAC - Storage Worker - Transcripts Container  
resource "azurerm_role_assignment" "rbac_storage_worker_transcripts_container" {
  scope                = var.transcripts_container_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.storage_worker_uai.principal_id
}

# RBAC - Storage Worker - Service Bus - Receive
resource "azurerm_role_assignment" "rbac_storage_worker_queue_receive" {
  scope                = var.storage_queue_id
  role_definition_name = "Azure Service Bus Data Receiver"
  principal_id         = azurerm_user_assigned_identity.storage_worker_uai.principal_id
}

# RBAC - Storage Worker - Service Bus - Send
resource "azurerm_role_assignment" "rbac_storage_worker_queue_send" {
  scope                = var.storage_queue_id
  role_definition_name = "Azure Service Bus Data Sender"
  principal_id         = azurerm_user_assigned_identity.storage_worker_uai.principal_id
}

# FIC - Storage Worker 
resource "azurerm_federated_identity_credential" "storage_worker_fic" {
  name      = "storage-worker-fic"
  parent_id = azurerm_user_assigned_identity.storage_worker_uai.id
  issuer    = var.aks_oidc
  subject   = "system:serviceaccount:storage-stt:storage-worker-sa"
  audience  = ["api://AzureADTokenExchange"]

  depends_on = [azurerm_user_assigned_identity.storage_worker_uai]
}