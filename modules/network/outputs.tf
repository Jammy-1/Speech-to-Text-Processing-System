# VNet 
output "vnet_id" { value = azurerm_virtual_network.main.id }

# Subnet
output "aks_subnet_id" { value = azurerm_subnet.aks.id }
output "ingress_subnet_id" { value = azurerm_subnet.ingress.id }
