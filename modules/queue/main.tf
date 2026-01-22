# Service Bus
resource "azurerm_servicebus_namespace" "service_bus" {
  name                = var.service_bus_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  sku                           = "Standard"
  public_network_access_enabled = false
}

# Queue - Speech
resource "azurerm_servicebus_queue" "speech_queue" {
  name                         = "speech-queue"
  namespace_id                 = azurerm_servicebus_namespace.service_bus.id

  max_size_in_megabytes        = 1024
  max_delivery_count = 5

  partitioning_enabled         = true
  requires_duplicate_detection = true

  lock_duration = "PT5M"
  default_message_ttl = "P7D"
  dead_lettering_on_message_expiration = true
}

# Queue - Search
resource "azurerm_servicebus_queue" "search_queue" {
  name                         = "search-queue"
  namespace_id                 = azurerm_servicebus_namespace.service_bus.id

  max_size_in_megabytes        = 1024
  max_delivery_count = 5

  partitioning_enabled         = true
  requires_duplicate_detection = true

  lock_duration = "PT5M"
  default_message_ttl = "P7D"
  dead_lettering_on_message_expiration = true
}
