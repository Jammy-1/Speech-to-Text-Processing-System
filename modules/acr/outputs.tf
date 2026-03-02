# ACR
output "acr_id" {
  value     = azurerm_container_registry.acr.id
  sensitive = true
}

output "acr_login_server" {
  value     = azurerm_container_registry.acr.login_server
  sensitive = true
}