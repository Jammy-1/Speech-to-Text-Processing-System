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

# ACR Encryption Key
output "acr_encryption_key_id" {
  value     = azurerm_key_vault_key.acr_encryption_key.id
  sensitive = true
}

# AKS Encryption Key
output "aks_disk_encryption_key_id" {
  value     = azurerm_key_vault_key.aks_encryption_key.id
  sensitive = true
}

# Service Bus Encryption Key
output "service_bus_encryption_key_id" {
  value     = azurerm_key_vault_key.service_bus_encryption_key.id
  sensitive = true
}

# Speech Key
output "speech_key_name" { value = azurerm_key_vault_secret.speech_key.name }
output "speech_secret_id" {
  value     = azurerm_key_vault_secret.speech_key.id
  sensitive = true
}

# Search Key 
output "search_key_name" { value = azurerm_key_vault_secret.search_key.name }
output "search_secret_id" {
  value     = azurerm_key_vault_secret.search_key.id
  sensitive = true
}

