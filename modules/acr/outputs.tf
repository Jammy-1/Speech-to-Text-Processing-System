# ACR
output "acr_id" { value = azurerm_container_registry.main.id }
output "acr_login_server" { value = azurerm_container_registry.main.login_server }

# UAI - CI/CD 
output "ci_cd_uai_client_id" { value = azurerm_user_assigned_identity.ci_cd_uai.client_id }