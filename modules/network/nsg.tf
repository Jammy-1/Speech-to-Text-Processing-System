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

# NSG - Private Endpoint
resource "azurerm_network_security_group" "pe_nsg" {
  name                = var.nsg_name_pe
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# NSG - Queue
resource "azurerm_network_security_group" "queue_nsg" {
  name                = var.nsg_name_queue
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# NSG - Monitoring
resource "azurerm_network_security_group" "monitoring_nsg" {
  name                = var.nsg_name_monitoring
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# AKS Association To NSG
resource "azurerm_subnet_network_security_group_association" "nsg_assoc_aks" {
  subnet_id                 = azurerm_subnet.aks.id
  network_security_group_id = azurerm_network_security_group.aks_nsg.id
}


# Private Endpoint Association To NSG
resource "azurerm_subnet_network_security_group_association" "nsg_assoc_pe" {
  subnet_id                 = azurerm_subnet.pe.id
  network_security_group_id = azurerm_network_security_group.pe_nsg.id
}

# Queue Association To NSG
resource "azurerm_subnet_network_security_group_association" "nsg_assoc_queue" {
  subnet_id                 = azurerm_subnet.queue.id
  network_security_group_id = azurerm_network_security_group.queue_nsg.id
}

# Monitoring Association To NSG
resource "azurerm_subnet_network_security_group_association" "nsg_assoc_monitoring" {
  subnet_id                 = azurerm_subnet.monitoring.id
  network_security_group_id = azurerm_network_security_group.monitoring_nsg.id
}

