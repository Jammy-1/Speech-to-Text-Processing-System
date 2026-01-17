# Private DNS - Storage
resource "azurerm_private_dns_zone" "storage_dns" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Private DNS - Speech
resource "azurerm_private_dns_zone" "search_dns" {
  name                = "privatelink.search.windows.net"
  resource_group_name = var.resource_group_name
}

# DNS Link - Storage
resource "azurerm_private_dns_zone_virtual_network_link" "storage_link" {
  name                  = var.storage_dns_link_name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.storage_dns.name
  virtual_network_id    = azurerm_virtual_network.main.id
}

# DNS Link - Speech
resource "azurerm_private_dns_zone_virtual_network_link" "search_link" {
  name                  = var.speech_dns_link_name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.search_dns.name
  virtual_network_id    = azurerm_virtual_network.main.id
}




