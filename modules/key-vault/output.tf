# Keyvault
output "key_vault_name" { value = azurerm_key_vault.main.name }
output "key_vault_id" { value = azurerm_key_vault.main.id }
output "key_vault_uri" { value = azurerm_key_vault.main.vault_uri }

output "acr_encryption_key_id" { value = azurerm_key_vault_key.acr_encryption_key.id }

# Speech Key
output "speech_key_name" { value = azurerm_key_vault_secret.speech_key.name }
