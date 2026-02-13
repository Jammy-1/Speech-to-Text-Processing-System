# Storage Account ID
output "storage_account_id" { value = azurerm_storage_account.storage_account.id }

# Storage Account Name
output "storage_account_name" { value = azurerm_storage_account.storage_account.name }

# Containers
output "blob_endpoint" { value = azurerm_storage_account.storage_account.primary_blob_endpoint }

output "audio_container_name" { value = azurerm_storage_container.audio.name }
output "audio_container_id" { value = azurerm_storage_container.audio.id }

output "transcripts_container_name" { value = azurerm_storage_container.transcripts.name }
output "transcripts_container_id" { value = azurerm_storage_container.transcripts.id }
