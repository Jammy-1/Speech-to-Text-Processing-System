# NSG - AKS
resource "azurerm_network_security_group" "aks_nsg" {
  name                = var.nsg_name_aks
  location            = var.location
  resource_group_name = var.resource_group_name
}

# AKS Assocation To NSG
resource "azurerm_subnet_network_security_group_association" "nsg_assoc_aks" {
  subnet_id                 = azurerm_subnet.aks.id
  network_security_group_id = azurerm_network_security_group.aks_nsg.id
}

# NSG - Ingress
resource "azurerm_network_security_group" "ingress_nsg" {
  name                = var.nsg_name_ingress
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Ingress Assocation To NSG
resource "azurerm_subnet_network_security_group_association" "nsg_assoc_ingress" {
  subnet_id                 = azurerm_subnet.ingress.id
  network_security_group_id = azurerm_network_security_group.ingress_nsg.id
}
