# VNet 
output "vnet_id" { value = azurerm_virtual_network.main.id }

# Subnet
output "aks_subnet_id" { value = azurerm_subnet.aks.id }
output "ingress_subnet_id" { value = azurerm_subnet.ingress.id }

# Public Ip 
output "public_ip_frontend" { value = azurerm_public_ip.frontend.ip_address }
output "public_ip_app_gw" { value = azurerm_public_ip.app_gw.ip_address }

# ACR
output "acr_subnet_id" { value = azurerm_subnet.acr.id }
output "acr_dns_id" { value = azurerm_private_dns_zone.acr_dns.id }