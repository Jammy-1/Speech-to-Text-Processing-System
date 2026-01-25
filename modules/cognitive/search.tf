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

# Search Service 
resource "azurerm_search_service" "search_service" {
  name                = var.search_service_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  sku             = "basic"
  replica_count   = 1
  partition_count = 1

  public_network_access_enabled = false
  network_rule_bypass_option    = "None"

  identity {
    type         = "SystemAssigned"
    identity_ids = [azurerm_user_assigned_identity.search_service_uai.id]
  }
}

# UAI - Search Service
resource "azurerm_user_assigned_identity" "search_service_uai" {
  name                = var.uai_name_search_service
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# RBAC - Search Service
resource "azurerm_role_assignment" "search_service_rbac" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.search_service_uai.principal_id
}


# Search Index
resource "azapi_resource" "transcripts_index" {
  type      = "Microsoft.Search/searchServices/indexes@2023-07-01"
  name      = "${azurerm_search_service.search_service.name}/transcripts-index"
  parent_id = azurerm_search_service.search_service.id

  schema_validation_enabled = false

  body = {
    properties = {
      fields = [
        { name = "chunk_id", type = "Edm.String", key = true, filterable = false },
        { name = "file_id", type = "Edm.String", filterable = true, sortable = true },
        { name = "session_id", type = "Edm.String", filterable = true },
        { name = "conversation_id", type = "Edm.String", filterable = true },
        { name = "chunk_index", type = "Edm.Int32", filterable = true, sortable = true },
        { name = "speaker", type = "Edm.String", filterable = true },
        { name = "start_time", type = "Edm.Double", filterable = true, sortable = true },
        { name = "end_time", type = "Edm.Double", filterable = true, sortable = true },
        { name = "duration", type = "Edm.Double", filterable = true, sortable = true },
        { name = "language", type = "Edm.String", filterable = true },
        { name = "transcript_chunk", type = "Edm.String", searchable = true, analyzer = "en.microsoft" },
        { name = "confidence_score", type = "Edm.Double", filterable = true, sortable = true },
        { name = "audio_file_name", type = "Edm.String", filterable = true, sortable = true },
        { name = "embedding", type = "Collection(Edm.Single)", searchable = true, dimensions = 1536, vectorSearchConfiguration = "vector-config" }
      ]
      vectorSearch = { algorithmConfigurations = [{ name = "vector-config", kind = "hnsw", hnswParameters = { metric = "cosine" } }] }
      semantic     = { configurations = [{ name = "semantic-config", prioritizedFields = { contentFields = [{ name = "transcript_chunk" }] } }] }
    }
  }
}
