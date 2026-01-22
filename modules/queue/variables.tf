# General
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "tags" { type = map(string) }

# Service Bus
variable "service_bus_name" { type = string }