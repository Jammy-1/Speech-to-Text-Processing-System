# Keyvault
output "key_vault_name" { value = azurerm_key_vault.key_vault.name }
output "key_vault_id" {
  value     = azurerm_key_vault.key_vault.id
  sensitive = true
}

# Key Vault URI
output "key_vault_uri" {
  value     = azurerm_key_vault.key_vault.vault_uri
  sensitive = true
}

# Speech Key
output "speech_key_name" { value = azurerm_key_vault_secret.speech_secret.name }

# Search Key 
output "search_key_name" {
  value = azurerm_key_vault_secret.search_secret.name
}

