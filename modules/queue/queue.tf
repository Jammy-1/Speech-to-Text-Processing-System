# Service Bus
resource "azurerm_servicebus_namespace" "service_bus" {
  name                = var.service_bus_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  sku      = "Premium"
  capacity = 2

  premium_messaging_partitions = "2"

  public_network_access_enabled = true
  local_auth_enabled            = false
  minimum_tls_version           = "1.2"

  identity {
    type         = "UserAssigned"
    identity_ids = [var.service_bus_uai_id]
  }
}

# Queue - Speech
resource "azurerm_servicebus_queue" "speech_queue" {
  name         = var.speech_queue_name
  namespace_id = azurerm_servicebus_namespace.service_bus.id

  max_size_in_megabytes = 1024
  max_delivery_count    = 5

  partitioning_enabled         = true
  requires_duplicate_detection = true

  lock_duration                        = "PT5M"
  default_message_ttl                  = "P7D"
  dead_lettering_on_message_expiration = true
}

# Queue - Search
resource "azurerm_servicebus_queue" "search_queue" {
  name         = var.search_queue_name
  namespace_id = azurerm_servicebus_namespace.service_bus.id

  max_size_in_megabytes = 1024
  max_delivery_count    = 5

  partitioning_enabled         = true
  requires_duplicate_detection = true

  lock_duration                        = "PT5M"
  default_message_ttl                  = "P7D"
  dead_lettering_on_message_expiration = true
}

# Queue - Storage
resource "azurerm_servicebus_queue" "storage_queue" {
  name         = var.storage_queue_name
  namespace_id = azurerm_servicebus_namespace.service_bus.id

  max_size_in_megabytes = 1024
  max_delivery_count    = 5

  partitioning_enabled         = true
  requires_duplicate_detection = true

  lock_duration                        = "PT5M"
  default_message_ttl                  = "P7D"
  dead_lettering_on_message_expiration = true
}