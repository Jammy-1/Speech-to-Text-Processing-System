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