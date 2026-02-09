# UAI & RBAC For Speech - modules\cognitive\speech.tf

# UAI Used On K8 Speech Worker
resource "azurerm_user_assigned_identity" "speech_worker_uai" {
  name                = var.uai_speech_worker_name
  resource_group_name = var.resource_group_name
  location            = var.location
}

# RBAC - Speech Worker - Storage - K8 Worker
resource "azurerm_role_assignment" "rbac_speech_worker_storage" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.speech_worker_uai.principal_id
}

# RBAC - K8 - Speech Worker  - Cognitve - K8 Worker
resource "azurerm_role_assignment" "rbac_cognitive_speech_worker" {
  scope                = var.speech_id
  role_definition_name = "Cognitive Services User"
  principal_id         = azurerm_user_assigned_identity.speech_worker_uai.principal_id
}
