# NSG - AKS
resource "azurerm_network_security_group" "aks_nsg" {
  name                = var.nsg_name_aks
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# NSG - Ingress
resource "azurerm_network_security_group" "ingress_nsg" {
  name                = var.nsg_name_ingress
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# AKS Assocation To NSG
resource "azurerm_subnet_network_security_group_association" "nsg_assoc_aks" {
  subnet_id                 = azurerm_subnet.aks.id
  network_security_group_id = azurerm_network_security_group.aks_nsg.id
}

# Ingress Assocation To NSG
resource "azurerm_subnet_network_security_group_association" "nsg_assoc_ingress" {
  subnet_id                 = azurerm_subnet.ingress.id
  network_security_group_id = azurerm_network_security_group.ingress_nsg.id
}
