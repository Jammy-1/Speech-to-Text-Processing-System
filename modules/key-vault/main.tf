# Key Vault
resource "azurerm_key_vault" "main" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  enabled_for_disk_encryption = true
  rbac_authorization_enabled  = true

  tenant_id                  = var.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = false
  soft_delete_retention_days = 7
}

# UAI - CI/CD - KV Admin
resource "azurerm_user_assigned_identity" "ci_cd_uai_kv_admin" {
  name                = var.uai_ci_cd_kv_admin_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  depends_on = [ azurerm_key_vault.main ]
}

# RBAC - CI/CD - KV Admin
resource "azurerm_role_assignment" "rbac_ci_cd_kv_admin" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = azurerm_user_assigned_identity.ci_cd_uai_kv_admin.principal_id

  depends_on = [ azurerm_user_assigned_identity.ci_cd_uai_kv_admin ]
}

# Key - ACR Encryption 
resource "azurerm_key_vault_key" "acr_encryption_key" {
  name         = var.acr_encryption_key_name
  key_vault_id = azurerm_key_vault.main.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["encrypt", "decrypt"]

  tags = var.tags

  depends_on = [azurerm_key_vault.main]
}

# Secret - Speech Key
resource "azurerm_key_vault_secret" "speech_key" {
  name         = var.speech_key_name
  value        = var.speech_primary_key
  key_vault_id = azurerm_key_vault.main.id

  tags = var.tags

  depends_on = [azurerm_key_vault.main]
}

# Secret - Search Key
resource "azurerm_key_vault_secret" "search_key" {
  name         = var.search_key_name
  value        = var.search_primary_key
  key_vault_id = azurerm_key_vault.main.id

  tags = var.tags

  depends_on = [azurerm_key_vault.main]
}
