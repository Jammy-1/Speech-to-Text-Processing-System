# Public IP - Front End
resource "azurerm_public_ip" "frontend" {
  name                = var.public_ip_frontend_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  allocation_method = "Static"
  sku               = "Standard"
}

# Public IP - App Gateway
resource "azurerm_public_ip" "app_gw" {
  name                = var.public_ip_app_gw_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
  allocation_method   = "Static"
  sku                 = "Standard"
}
