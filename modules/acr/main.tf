# ACR
resource "azurerm_container_registry" "main" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  sku                           = "Premium"
  admin_enabled                 = false
  public_network_access_enabled = true

  retention_policy_in_days  = 30
  quarantine_policy_enabled = true
  trust_policy_enabled      = true


  network_rule_bypass_option = "AzureServices"
  network_rule_set { default_action = "Deny" }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.uai_acr_encryption_id]
  }

  encryption {
    key_vault_key_id   = var.acr_encryption_key_id
    identity_client_id = var.uai_acr_encryption_client_id
  }

  georeplications {
    location = "ukwest"
    tags     = var.tags
  }

  zone_redundancy_enabled = true
}
