resource "azurerm_storage_account" "main" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "audio" {
  name                  = "audio"
  storage_account_id    = var.storage_account_name
  container_access_type = "private"
}

resource "azurerm_storage_container" "transcripts" {
  name                  = "transcripts"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}
