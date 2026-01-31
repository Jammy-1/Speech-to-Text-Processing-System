# Public IP - AKS
resource "azurerm_public_ip" "aks_nat_ip" {
  name                = "aks-nat-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags = var.tags

  sku                 = "Standard"
  allocation_method   = "Static"
}

# Nat Gateway - AKS
resource "azurerm_nat_gateway" "aks_nat" {
  name                = "aks-nat-gateway"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags = var.tags

  sku_name            = "Standard"
}

# Nat Gateway - AKS Assoc
resource "azurerm_nat_gateway_public_ip_association" "aks_nat_ip_assoc" {
  nat_gateway_id        = azurerm_nat_gateway.aks_nat.id
  public_ip_address_id  = azurerm_public_ip.aks_nat_ip.id
}

# Subnet / NAT - AKS - Assoc 
resource "azurerm_subnet_nat_gateway_association" "aks_subnet_nat" {
  subnet_id      = azurerm_subnet.aks.id
  nat_gateway_id = azurerm_nat_gateway.aks_nat.id
}
