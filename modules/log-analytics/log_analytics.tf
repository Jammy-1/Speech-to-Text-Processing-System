resource "azurerm_log_analytics_workspace" "main" {
  name                = var.log_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  sku               = "PerGB2018"
  retention_in_days = "30"
}

# Monitoring - Storage
resource "azurerm_monitor_diagnostic_setting" "storage_logs" {
  name                       = var.storage_log_name
  target_resource_id         = var.storage_account_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_metric { category = "Capacity" }
  enabled_metric { category = "Transaction" }
}