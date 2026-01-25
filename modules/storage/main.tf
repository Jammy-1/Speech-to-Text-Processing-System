# Storage Account
resource "azurerm_storage_account" "main" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  tags                     = var.tags
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Container - Audio 
resource "azurerm_storage_container" "audio" {
  name                  = "audio"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}

# Container - Transcripts
resource "azurerm_storage_container" "transcripts" {
  name                  = "transcripts"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}
