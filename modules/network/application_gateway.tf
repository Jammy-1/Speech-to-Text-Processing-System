# Application Gateway
resource "azurerm_application_gateway" "appgw" {
  name                = var.app_gw_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  sku {
    name = "Standard_v2"
    tier = "Standard_v2"
  }

  autoscale_configuration {
    min_capacity = "1"
    max_capacity = "2"
  }

  gateway_ip_configuration {
    name      = var.app_gw_ip_config_name
    subnet_id = azurerm_subnet.ingress.id
  }

  # Attched Frontend Public IP
  frontend_ip_configuration {
    name                 = var.app_gw_frontend_ip_config_name
    public_ip_address_id = azurerm_public_ip.app_gw.id
  }

  frontend_port {
    name = "http-port"
    port = 80
  }

  # Backend Pool To AKS LB IP
  backend_address_pool {
    name         = var.app_gw_aks_backend_pool_ip_name
    ip_addresses = ["10.0.1.10"]
  }


  backend_http_settings {
    name                  = "http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }

  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = var.app_gw_frontend_ip_config_name
    frontend_port_name             = "http-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "route-http-to-aks-backend"
    priority                   = 100
    rule_type                  = "Basic"
    http_listener_name         = "http-listener"
    backend_address_pool_name  = var.app_gw_aks_backend_pool_ip_name
    backend_http_settings_name = "http-settings"
  }
}
