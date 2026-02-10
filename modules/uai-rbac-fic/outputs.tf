# Speech 
output "speech_worker_uai_principal_id" { value = azurerm_user_assigned_identity.speech_worker_uai.principal_id }

# API
output "uai_api_worker_client_id" { value = azurerm_user_assigned_identity.api_uai.client_id }

