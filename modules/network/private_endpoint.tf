# Private Endpoint - Speech
resource "azurerm_private_endpoint" "speech_pe" {
  name                = var.private_endpoint_name_speech_pe
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  subnet_id = azurerm_subnet.pe.id

  private_service_connection {
    name                           = "speech-psc"
    is_manual_connection           = false
    private_connection_resource_id = var.speech_id
    subresource_names              = ["speech"]
  }

  private_dns_zone_group {
    name                 = var.speech_dns_group_name
    private_dns_zone_ids = [azurerm_private_dns_zone.speech_dns.id]
  }
}

# Private Endpoint - Search
resource "azurerm_private_endpoint" "search_pe" {
  name                = var.private_endpoint_name_search_pe
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  subnet_id = azurerm_subnet.pe.id

  private_service_connection {
    name                           = "search-psc"
    is_manual_connection           = false
    private_connection_resource_id = var.search_id
    subresource_names              = ["search"]
  }

  private_dns_zone_group {
    name                 = var.search_dns_group_name
    private_dns_zone_ids = [azurerm_private_dns_zone.search_dns.id]
  }
}

# Private Endpoint - Storage
resource "azurerm_private_endpoint" "storage_pe" {
  name                = var.private_endpoint_name_storage_pe
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  subnet_id = azurerm_subnet.pe.id

  private_service_connection {
    name                           = "storage-connection"
    is_manual_connection           = false
    private_connection_resource_id = var.storage_account_id
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = var.storage_dns_group_name
    private_dns_zone_ids = [azurerm_private_dns_zone.storage_dns.id]
  }
}

# Private Endpoint - Queue
resource "azurerm_private_endpoint" "queue_pe" {
  name                = var.private_endpoint_name_queue_pe
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  subnet_id = azurerm_subnet.queue.id

  private_service_connection {
    name                           = "queue-psc"
    is_manual_connection           = false
    private_connection_resource_id = var.service_bus_id
    subresource_names              = ["namespace"]
  }

  private_dns_zone_group {
    name                 = var.queue_dns_group_name
    private_dns_zone_ids = [azurerm_private_dns_zone.queue_dns.id]
  }
}
