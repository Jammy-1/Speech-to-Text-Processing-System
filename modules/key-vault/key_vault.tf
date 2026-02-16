data "azurerm_client_config" "current" {}

# Key Vault
resource "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  enabled_for_disk_encryption = true
  rbac_authorization_enabled  = true

  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = false
  soft_delete_retention_days = 90

  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    virtual_network_subnet_ids = [var.pe_subnet_id]
  }
}

# Key - ACR Encryption 
resource "azurerm_key_vault_key" "acr_encryption_key" {
  name            = var.acr_encryption_key_name
  key_vault_id    = azurerm_key_vault.key_vault.id
  key_type        = "RSA-HSM"
  key_size        = 2048
  key_opts        = ["encrypt", "decrypt"]
  expiration_date = timeadd(timestamp(), "4380h")

  tags = var.tags

  depends_on = [azurerm_key_vault.key_vault]
}

# Key - AKS Encryption 
resource "azurerm_key_vault_key" "aks_encryption_key" {
  name            = var.aks_disk_encryption_key_name
  key_vault_id    = azurerm_key_vault.key_vault.id
  key_type        = "RSA-HSM"
  key_size        = 2048
  key_opts        = ["encrypt", "decrypt"]
  expiration_date = timeadd(timestamp(), "4380h")

  tags = var.tags

  depends_on = [azurerm_key_vault.key_vault]
}

# Key - Service Bus Encryption 
resource "azurerm_key_vault_key" "service_bus_encryption_key" {
  name            = var.servicebus_encryption_key_name
  key_vault_id    = azurerm_key_vault.key_vault.id
  key_type        = "RSA-HSM"
  key_size        = 2048
  key_opts        = ["encrypt", "decrypt"]
  expiration_date = timeadd(timestamp(), "4380h")

  tags = var.tags

  depends_on = [azurerm_key_vault.key_vault]
}

# Secret - Speech Key
resource "azurerm_key_vault_secret" "speech_key" {
  name         = var.speech_key_name
  value        = var.speech_primary_key
  key_vault_id = azurerm_key_vault.key_vault.id

  content_type    = "text/plain"
  expiration_date = timeadd(timestamp(), "4380h")

  tags = var.tags

  depends_on = [azurerm_key_vault.key_vault]
}

# Secret - Search Key
resource "azurerm_key_vault_secret" "search_key" {
  name         = var.search_key_name
  value        = var.search_primary_key
  key_vault_id = azurerm_key_vault.key_vault.id

  content_type    = "text/plain"
  expiration_date = timeadd(timestamp(), "4380h")

  tags = var.tags

  depends_on = [azurerm_key_vault.key_vault]
}
