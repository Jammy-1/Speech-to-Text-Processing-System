# VNet
resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  address_space = ["10.0.0.0/16"]
}

# Storage DNS Link
resource "azurerm_private_dns_zone_virtual_network_link" "storage_link" {
  name                  = var.storage_dns_link_name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.storage_dns.name
  virtual_network_id    = azurerm_virtual_network.main.id
}