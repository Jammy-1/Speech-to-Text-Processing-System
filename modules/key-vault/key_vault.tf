data "azurerm_client_config" "kv_tennant_id" {}
# Key Vault
resource "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  enabled_for_disk_encryption = true
  rbac_authorization_enabled  = true

  tenant_id                  = data.azurerm_client_config.kv_tennant_id.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = false
  soft_delete_retention_days = 90

  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    virtual_network_subnet_ids = [var.pe_subnet_id]
  }
}

# Speech
data "azurerm_cognitive_account" "speech" {
  name                = var.speech_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_key_vault_secret" "speech_secret" {
  name         = "speech-primary-key"
  value        = data.azurerm_cognitive_account.speech.primary_access_key
  key_vault_id = azurerm_key_vault.key_vault.id
}

# Search
data "azurerm_search_service" "search" {
  name                = var.search_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_key_vault_secret" "search_secret" {
  name         = var.search_key_name
  value        = data.azurerm_search_service.search.primary_key
  key_vault_id = azurerm_key_vault.key_vault.id
}

# RBAC - Service Principal - KV Admin
data "azurerm_client_config" "rbac_service_principal_kv_admin" {}
resource "azurerm_role_assignment" "rbac_service_principal_kv_admin" {
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.rbac_service_principal_kv_admin.object_id

  depends_on = [azurerm_key_vault.key_vault]
}