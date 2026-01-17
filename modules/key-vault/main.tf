# Key Vault
resource "azurerm_key_vault" "main" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = true
  soft_delete_retention_days  = 90
}

# RBAC - AKS
resource "azurerm_role_assignment" "rbac_aks" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.aks_principal_id
}

# RBAC - AKS-ACR
resource "azurerm_role_assignment" "rbac_aks_acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = var.aks_principal_id
}

# Key - ACR Encryption 
resource "azurerm_key_vault_key" "acr_encryption_key" {
  name         = var.acr_encryption_key_name
  key_vault_id = azurerm_key_vault.main.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["encrypt", "decrypt"]

  tags = var.tags
}

# Secret - Speech Key
resource "azurerm_key_vault_secret" "speech_key" {
  name         = var.speech_key_name
  value        = var.speech_key
  key_vault_id = azurerm_key_vault.main.id

  tags = var.tags
}

