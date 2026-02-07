# Speech - Cognitive Account
resource "azurerm_cognitive_account" "speech_service" {
  name                = var.cognitive_account_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  kind     = "SpeechServices"
  sku_name = "S0"

  custom_subdomain_name              = "stt-speech-001"
  outbound_network_access_restricted = "true"
  public_network_access_enabled      = "false"
  local_auth_enabled                 = "false"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.cognitive_account_uai.id]
  }

  network_acls {
    default_action = "Deny"
    virtual_network_rules {
      subnet_id = var.pe_subnet_id
    }
  }
}

# UAI - CA -  Speech Service
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
