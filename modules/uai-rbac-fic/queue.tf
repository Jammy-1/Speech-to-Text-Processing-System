# UAI & RBAC For Queue - modules\queue

# RBAC - Speech - Speech Worker UAI Link
resource "azurerm_role_assignment" "rbac_service_bus_speech_worker" {
  scope                = var.service_bus_id
  role_definition_name = "Azure Service Bus Data Receiver"
  principal_id         = azurerm_user_assigned_identity.speech_worker_uai.principal_id
}
