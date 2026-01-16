# Subnet - AKS
resource "azurerm_subnet" "aks" {
  name                 = var.subnet_name_aks
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Subnet - Ingress
resource "azurerm_subnet" "ingress" {
  name                 = var.subnet_name_ingress
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

