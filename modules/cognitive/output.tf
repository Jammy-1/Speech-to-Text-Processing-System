# Speech
output "speech_name" { value = azurerm_cognitive_account.speech_service.name }
output "speech_id" {
  value     = azurerm_cognitive_account.speech_service.id
  sensitive = true
}

output "speech_endpoint" {
  value     = azurerm_cognitive_account.speech_service.endpoint
  sensitive = true
}

# Search
output "search_name" { value = azurerm_search_service.search_service.name }
output "transcripts_index_name" { value = azapi_data_plane_resource.transcripts_index.name }
output "search_id" {
  value     = azurerm_search_service.search_service.id
  sensitive = true
}

output "search_endpoint" {
  value     = "https://${azurerm_search_service.search_service.name}.search.windows.net"
  sensitive = true
}

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