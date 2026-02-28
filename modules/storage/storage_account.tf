# Storage Account
resource "azurerm_storage_account" "storage_account" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version          = "TLS1_2"

  public_network_access_enabled = true

  network_rules {
    default_action             = "Deny"
    bypass                     = ["Logging", "Metrics", "AzureServices"]
    virtual_network_subnet_ids = [var.pe_subnet_id]
  }
}

# Container - Audio 
resource "azurerm_storage_container" "audio" {
  name                  = "audio"
  storage_account_id    = azurerm_storage_account.storage_account.id
  container_access_type = "private"
}

# Container - Transcripts
resource "azurerm_storage_container" "transcripts" {
  name                  = "transcripts"
  storage_account_id    = azurerm_storage_account.storage_account.id
  container_access_type = "private"
}
