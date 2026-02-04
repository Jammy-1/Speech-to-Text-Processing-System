# Providers - AzApi For Search Index
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "2.8.0"
    }
  }
}

data "azurerm_client_config" "current" {}

# Search Service 
resource "azurerm_search_service" "search_service" {
  name                = var.search_service_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  sku             = "basic"
  replica_count   = 1
  partition_count = 1

  public_network_access_enabled = true
  local_authentication_enabled  = true
  authentication_failure_mode   = "http403"
}

# Search Index
resource "azapi_data_plane_resource" "example" {
  type      = "Microsoft.Search/searchServices/indexes@2024-07-01"
  parent_id = "${azurerm_search_service.name}.search.windows.net"
  name      = "transcripts-index"
  body = {
    fields = [
      { name = "chunk_id", type = "Edm.String", key = true, filterable = false },
      { name = "audio_file_name", type = "Edm.String", filterable = true, sortable = true },
      { name = "file_id", type = "Edm.String", filterable = true, sortable = true },
      { name = "session_id", type = "Edm.String", filterable = true },
      { name = "chunk_index", type = "Edm.Int32", filterable = true, sortable = true },
      { name = "start_time", type = "Edm.Double", filterable = true, sortable = true },
      { name = "end_time", type = "Edm.Double", filterable = true, sortable = true },
      { name = "duration", type = "Edm.Double", filterable = true, sortable = true },
      { name = "language", type = "Edm.String", filterable = true },
      { name = "transcript_chunk", type = "Edm.String", searchable = true, analyzer = "en.microsoft" },
    ]
  }
  depends_on = [
    azurerm_role_assignment.search_index_contributor,
  ]
}

# Role Definition- Seearch Index
data "azurerm_role_definition" "search_index_data_contributor" {
  name  = "Search Index Data Contributor"
  scope = azurerm_search_service.search_service.id
}

# RBAC - Search Index
resource "azurerm_role_assignment" "search_index_contributor" {
  scope              = azurerm_search_service.search_service.id
  role_definition_id = data.azurerm_role_definition.search_index_data_contributor.id
  principal_id       = data.azurerm_client_config.current.object_id
}

# RBAC - Search Service
resource "azurerm_role_assignment" "search_service_rbac" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.search_service_uai.principal_id
}

# UAI - Search Service
resource "azurerm_user_assigned_identity" "search_service_uai" {
  name                = var.uai_name_search_service
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}
