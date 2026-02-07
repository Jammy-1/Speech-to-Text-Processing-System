# VNet 
output "vnet_id" { value = azurerm_virtual_network.main.id }
output "vnet_name" { value = azurerm_virtual_network.main.name }

# Subnet
output "aks_subnet_id" { value = azurerm_subnet.aks.id }
output "ingress_subnet_id" { value = azurerm_subnet.ingress.id }
output "pe_subnet_id" { value = azurerm_subnet.pe.id }

output "aks_subnet_name" { value = azurerm_subnet.aks.name }
output "acr_subnet_name" { value = azurerm_subnet.acr.name }
output "ingress_subnet_name" { value = azurerm_subnet.ingress.name }
output "monitoring_subnet_name" { value = azurerm_subnet.monitoring.name }
output "queue_subnet_name" { value = azurerm_subnet.queue.name }
output "pe_subnet_name" { value = azurerm_subnet.pe.name }

output "aks_subnet_address_prefixes" { value = azurerm_subnet.aks.address_prefixes }
output "acr_subnet_address_prefixes" { value = azurerm_subnet.acr.address_prefixes }
output "ingress_subnet_address_prefixes" { value = azurerm_subnet.ingress.address_prefixes }
output "monitoring_subnet_address_prefixes" { value = azurerm_subnet.monitoring.address_prefixes }
output "queue_subnet_address_prefixes" { value = azurerm_subnet.queue.address_prefixes }
output "pe_subnet_address_prefixes" { value = azurerm_subnet.pe.address_prefixes }

# Public Ip 
output "public_ip_frontend" { value = azurerm_public_ip.frontend.ip_address }
output "public_ip_app_gw" { value = azurerm_public_ip.app_gw.ip_address }

# ACR
output "acr_subnet_id" { value = azurerm_subnet.acr.id }
output "acr_dns_id" { value = azurerm_private_dns_zone.acr_dns.id }