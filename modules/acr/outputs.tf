# ACR
output "acr_id" {
  value     = azurerm_container_registry.main.id
  sensitive = true
}

output "acr_login_server" {
  value     = azurerm_container_registry.main.login_server
  sensitive = true
}