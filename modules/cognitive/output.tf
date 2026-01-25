# Speech
output "speech_id" { value = azurerm_cognitive_account.speech_service.id }
output "speech_endpoint" { value = azurerm_cognitive_account.speech_service.endpoint }

# Search
output "search_name" { value = azurerm_search_service.search_service.name }
output "search_endpoint" { value = "https://${azurerm_search_service.search_service.name}.search.windows.net" }
output "transcripts_index_name" { value = azapi_resource.transcripts_index.name }

# Key - Speech
output "speech_primary_key" {
  value     = azurerm_cognitive_account.speech_service.primary_access_key
  sensitive = true
}

# Key - Search
output "search_primary_key" {
  value     = azurerm_search_service.search_service.primary_key
  sensitive = true
}