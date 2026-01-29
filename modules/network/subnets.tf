# Subnet - AKS
resource "azurerm_subnet" "aks" {
  name                = var.subnet_name_aks
  resource_group_name = var.resource_group_name

  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Subnet - Ingress
resource "azurerm_subnet" "ingress" {
  name                = var.subnet_name_ingress
  resource_group_name = var.resource_group_name

  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Subnet - Private Endpoints
resource "azurerm_subnet" "pe" {
  name                 = var.subnet_name_pe
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.3.0/24"]
}

# Subnet - Queue
resource "azurerm_subnet" "queue" {
  name                 = var.subnet_name_queue
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.4.0/28"]
}

# Subnet - Monitoring
resource "azurerm_subnet" "monitoring" {
  name                 = var.subnet_name_monitoring
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.5.0/28"]
}

# Subnet - ACR
resource "azurerm_subnet" "acr" {
  name                 = var.subnet_name_acr
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.6.0/28"]
}