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
    identity_ids = [var.cognitive_account_uai_id]
  }

  network_acls {
    default_action = "Deny"
    virtual_network_rules {
      subnet_id = var.pe_subnet_id
    }
  }
}

