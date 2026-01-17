# Public IP - Front End
resource "azurerm_public_ip" "frontend" {
  name                = var.public_ip_frontend_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Public IP - AKS LoadBalancer
resource "azurerm_public_ip" "aks_lb" {
  name                = var.public_ip_aks_lb_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}
