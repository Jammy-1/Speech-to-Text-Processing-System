# Storage Private Endpoint
resource "azurerm_private_endpoint" "storage_pe" {
  name                = var.private_endpoint_name_storage_pe
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  subnet_id = azurerm_subnet.aks.id

  private_service_connection {
    name                           = "storage-connection"
    is_manual_connection           = false
    private_connection_resource_id = var.storage_account_id
    subresource_names              = ["blob"]
  }
}

# Private DNS - Storage
resource "azurerm_private_dns_zone" "storage_dns" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

