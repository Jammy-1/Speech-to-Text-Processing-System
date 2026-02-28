# UAI & RBAC For Queue - modules\queue

# RBAC - Speech Worker - Service Bus Receive 
resource "azurerm_role_assignment" "rbac_service_bus_speech_worker_receive" {
  scope                = var.speech_queue_id
  role_definition_name = "Azure Service Bus Data Receiver"
  principal_id         = azurerm_user_assigned_identity.speech_worker_uai.principal_id
}

# RBAC - Search Worker - Service Bus Receive 
resource "azurerm_role_assignment" "rbac_service_bus_search_worker_receive" {
  scope                = var.search_queue_id
  role_definition_name = "Azure Service Bus Data Receiver"
  principal_id         = azurerm_user_assigned_identity.search_worker_uai.principal_id
}

# RBAC - Storage Worker - Service Bus Receive 
resource "azurerm_role_assignment" "rbac_service_bus_storage_worker_receive" {
  scope                = var.storage_queue_id
  role_definition_name = "Azure Service Bus Data Receiver"
  principal_id         = azurerm_user_assigned_identity.storage_worker_uai.principal_id
}

# RBAC - API - Send
resource "azurerm_role_assignment" "rbac_service_bus_api_send" {
  scope                = var.service_bus_id
  role_definition_name = "Azure Service Bus Data Sender"
  principal_id         = azurerm_user_assigned_identity.uai_aks.principal_id
}