# NSG Rules - AKS
resource "azurerm_network_security_rule" "aks_rules" {
  for_each = { for idx, rule in var.security_rules_aks : idx => rule }

  name                        = each.value.name
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.aks_nsg.name

  priority  = each.value.priority
  direction = each.value.direction
  access    = each.value.access
  protocol  = each.value.protocol

  # Source
  source_address_prefix                 = lookup(each.value, "source_address_prefix", null)
  source_address_prefixes               = lookup(each.value, "source_address_prefixes", null)
  source_application_security_group_ids = lookup(each.value, "source_application_security_group_ids", null)

  # Destination
  destination_address_prefix                 = lookup(each.value, "destination_address_prefix", null)
  destination_address_prefixes               = lookup(each.value, "destination_address_prefixes", null)
  destination_application_security_group_ids = lookup(each.value, "destination_application_security_group_ids", null)

  depends_on = [azurerm_network_security_group.aks_nsg]
}


# NSG Rules - Ingress
resource "azurerm_network_security_rule" "ingress_rules" {
  for_each = { for idx, rule in var.security_rules_ingress : idx => rule }

  name                        = each.value.name
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.ingress_nsg.name

  priority  = each.value.priority
  direction = each.value.direction
  access    = each.value.access
  protocol  = each.value.protocol

  source_port_range      = lookup(each.value, "source_port_range", "*")
  destination_port_range = lookup(each.value, "destination_port_range", "*")

  # Source
  source_address_prefix                 = lookup(each.value, "source_address_prefix", null)
  source_address_prefixes               = lookup(each.value, "source_address_prefixes", null)
  source_application_security_group_ids = lookup(each.value, "source_application_security_group_ids", null)

  # Destination
  destination_address_prefix                 = lookup(each.value, "destination_address_prefix", null)
  destination_address_prefixes               = lookup(each.value, "destination_address_prefixes", null)
  destination_application_security_group_ids = lookup(each.value, "destination_application_security_group_ids", null)

  depends_on = [azurerm_network_security_group.ingress_nsg]
}
