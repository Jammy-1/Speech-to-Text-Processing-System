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
resource "azapi_data_plane_resource" "transcripts_index" {
  type      = "Microsoft.Search/searchServices/indexes@2024-07-01"
  parent_id = "${azurerm_search_service.search_service.name}.search.windows.net"
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
    azurerm_search_service.search_service,
    var.rdef_search_index_data_contributor_name
  ]
}

# Attach UAI To Search Service 
resource "azapi_update_resource" "attach_uai_search_service" {
  type      = "Microsoft.Search/searchServices@2024-06-01-Preview"
  name      = azurerm_search_service.search_service.name
  parent_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"

  body = {
    identity = {
      type = "UserAssigned"
      userAssignedIdentities = {
        for uai_id in [var.search_service_uai_id] : uai_id => {}
      }
    }
  }

  depends_on = [
    azurerm_search_service.search_service,
    azapi_data_plane_resource.transcripts_index
  ]
}