# UAI & RBAC For Speech - modules\cognitive\speech.tf

# Speech Service 
# UAI - Cognitve Account -  Speech Service
resource "azurerm_user_assigned_identity" "cognitive_account_uai" {
  name                = var.uai_name_cognitive_account
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# RBAC - CA - Speech Service
resource "azurerm_role_assignment" "cognitive_rbac" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.cognitive_account_uai.principal_id
}


# Kubernetes - modules\kubernetes\speech.tf
# UAI Used On K8 Speech Worker
resource "azurerm_user_assigned_identity" "speech_worker_uai" {
  name                = var.uai_speech_worker_name
  resource_group_name = var.resource_group_name
  location            = var.location
}

# RBAC - Speech K8 Worker - Storage -  Audio Container  
resource "azurerm_role_assignment" "rbac_speech_worker_audio_container" {
  scope                = var.audio_container_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.speech_worker_uai.principal_id
}

# RBAC - Speech K8 Worker - Storage - Transcripts Container  
resource "azurerm_role_assignment" "rbac_speech_worker_transcripts_container" {
  scope                = var.transcripts_container_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.speech_worker_uai.principal_id
}

# RBAC - K8 - Speech Worker  - Speech 
resource "azurerm_role_assignment" "rbac_cognitive_speech_worker" {
  scope                = var.speech_id
  role_definition_name = "Cognitive Services User"
  principal_id         = azurerm_user_assigned_identity.speech_worker_uai.principal_id
}

# FIC - Speech Worker 
resource "azurerm_federated_identity_credential" "fic_speech_worker" {
  name                = "speech-worker-fic"
  parent_id           = azurerm_user_assigned_identity.speech_worker_uai.id
  issuer              = var.aks_oidc
  subject             = "system:serviceaccount:speech-stt:speech-worker-sa"
  audience            = ["api://AzureADTokenExchange"]

  depends_on = [azurerm_user_assigned_identity.speech_worker_uai]
}

