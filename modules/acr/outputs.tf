# ACR
output "acr_id" { 
 value = azurerm_container_registry.main.id
 sensitive = true
}

output "acr_login_server" { 
 value = azurerm_container_registry.main.login_server 
 sensitive = true 
}

# UAI  
output "acr_uai_principal_id" {
 value = azurerm_user_assigned_identity.acr_uai.id 
 sensitive = true
}

output "ci_cd_uai_acr_client_id" {
 value = azurerm_user_assigned_identity.ci_cd_uai_acr.client_id 
 sensitive = true
}