# VNet 
output "vnet_id" { value = azurerm_virtual_network.main.id }
output "vnet_name" { value = azurerm_virtual_network.main.name }

# Subnet - Private End Point
output "pe_subnet_id" { value = azurerm_subnet.pe.id }
output "pe_subnet_name" { value = azurerm_subnet.pe.name }
output "pe_subnet_address_prefixes" { value = azurerm_subnet.pe.address_prefixes }

# Subnet - AKS
output "aks_subnet_id" { value = azurerm_subnet.aks.id }
output "aks_subnet_name" { value = azurerm_subnet.aks.name }
output "aks_subnet_address_prefixes" { value = azurerm_subnet.aks.address_prefixes }

# Subnet - ACR
output "acr_subnet_name" { value = azurerm_subnet.acr.name }
output "acr_subnet_address_prefixes" { value = azurerm_subnet.acr.address_prefixes }

# Subnet - Ingress
output "ingress_subnet_id" { value = azurerm_subnet.ingress.id }
output "ingress_subnet_name" { value = azurerm_subnet.ingress.name }
output "ingress_subnet_address_prefixes" { value = azurerm_subnet.ingress.address_prefixes }

# Subnet - Monitoring 
output "monitoring_subnet_name" { value = azurerm_subnet.monitoring.name }
output "monitoring_subnet_address_prefixes" { value = azurerm_subnet.monitoring.address_prefixes }

# Subnet - Queue
output "queue_subnet_name" { value = azurerm_subnet.queue.name }
output "queue_subnet_address_prefixes" { value = azurerm_subnet.queue.address_prefixes }


# Public Ip 
output "public_ip_frontend" { value = azurerm_public_ip.frontend.ip_address }
output "public_ip_app_gw" { value = azurerm_public_ip.app_gw.ip_address }

# ACR
output "acr_subnet_id" { value = azurerm_subnet.acr.id }
output "acr_dns_id" { value = azurerm_private_dns_zone.acr_dns.id }