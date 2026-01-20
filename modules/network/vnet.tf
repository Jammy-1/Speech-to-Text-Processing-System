# VNet
resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  address_space = ["10.0.0.0/16"]
}

# DNS / VNet Link - Storage
resource "azurerm_private_dns_zone_virtual_network_link" "storage_link" {
  name                = var.storage_dns_link_name
  resource_group_name = var.resource_group_name
  tags                = var.tags

  private_dns_zone_name = azurerm_private_dns_zone.storage_dns.name
  virtual_network_id    = azurerm_virtual_network.main.id
}

# DNS / VNet Link - Speech
resource "azurerm_private_dns_zone_virtual_network_link" "speech_link" {
  name                = var.speech_dns_link_name
  resource_group_name = var.resource_group_name
  tags                = var.tags

  private_dns_zone_name = azurerm_private_dns_zone.search_dns.name
  virtual_network_id    = azurerm_virtual_network.main.id
}

# DNS / VNet Link - Search
resource "azurerm_private_dns_zone_virtual_network_link" "search_link" {
  name                = var.search_dns_link_name
  resource_group_name = var.resource_group_name
  tags                = var.tags

  private_dns_zone_name = azurerm_private_dns_zone.search_dns.name
  virtual_network_id    = azurerm_virtual_network.main.id
}