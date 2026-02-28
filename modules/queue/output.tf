# Service Bus
output "service_bus_id" { value = azurerm_servicebus_namespace.service_bus.id }
output "service_bus_namespace" { value = azurerm_servicebus_namespace.service_bus.name }

# Speech 
output "speech_queue_name" { value = azurerm_servicebus_queue.speech_queue.name }
output "speech_queue_id" { value = azurerm_servicebus_queue.speech_queue.id }

# Search
output "search_queue_name" { value = azurerm_servicebus_queue.search_queue.name }
output "search_queue_id" { value = azurerm_servicebus_queue.search_queue.id }

# Storage
output "storage_queue_name" { value = azurerm_servicebus_queue.storage_queue.name }
output "storage_queue_id" { value = azurerm_servicebus_queue.storage_queue.id }

