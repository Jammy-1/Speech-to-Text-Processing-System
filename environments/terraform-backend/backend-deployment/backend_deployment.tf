data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

# Resource Group
resource "azurerm_resource_group" "stt_state_resource_group" {
  name     = var.state_resource_group_name
  location = var.location
  tags     = merge(var.tags, var.backend_tags)
}

# Storage Account
resource "azurerm_storage_account" "stt_state_storage_account" {
  name                = var.state_storage_account_name
  resource_group_name = var.state_resource_group_name
  location            = var.location

  account_tier             = "Standard"
  account_replication_type = "LRS"

  public_network_access_enabled = "true"
  https_traffic_only_enabled    = true
  min_tls_version               = "TLS1_2"

  blob_properties {
    delete_retention_policy { days = 30 }
    versioning_enabled = true
  }

  depends_on = [azurerm_resource_group.stt_state_resource_group]

  tags = merge(var.tags, var.backend_tags)
}

# State Container
resource "azurerm_storage_container" "state_container" {
  name                  = var.state_storage_container_name
  storage_account_id    = azurerm_storage_account.stt_state_storage_account.id
  container_access_type = "private"
}

# RBAC - SP Access To Write State File
resource "azurerm_role_assignment" "rbac_state_storage_account" {
  scope                = azurerm_storage_account.stt_state_storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id

  depends_on = [azurerm_storage_account.stt_state_storage_account, azurerm_resource_group.stt_state_resource_group]
}

