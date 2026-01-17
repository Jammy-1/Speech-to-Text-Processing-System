# VNet 
output "vnet_id" { value = azurerm_virtual_network.main.id }

# Subnet
output "aks_subnet_id" { value = azurerm_subnet.aks.id }
output "ingress_subnet_id" { value = azurerm_subnet.ingress.id }

# Public Ip 
output "public_ip_frontend" { value = azurerm_public_ip.frontend.ip_address}
output "frontend_public_ip_aks" { value = azurerm_public_ip.aks_lb.ip_address}
