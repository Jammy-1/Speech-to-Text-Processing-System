resource "azurerm_kubernetes_cluster" "main" {
  name                    = var.kubernetes_cluster_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  private_cluster_enabled = true
  dns_prefix              = var.aks_dns

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_uai.id]
  }

  default_node_pool {
    name           = var.aks_node_pool_name
    vm_size        = var.aks_node_size
    vnet_subnet_id = var.aks_subnet_id

    auto_scaling_enabled = true
    min_count            = var.aks_node_scaling_min
    max_count            = var.aks_node_scaling_max

  }

  monitor_metrics {
    annotations_allowed = null
    labels_allowed      = null
  }

  oms_agent { log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id }

}

# UAI- AKS
resource "azurerm_user_assigned_identity" "aks_uai" {
  name                = var.uai_aks_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# RBAC - AKS
resource "azurerm_role_assignment" "rbac_aks_speech_key_access" {
  scope                = var.rbac_aks_speech_key_access
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.aks_uai.principal_id
}


resource "azurerm_log_analytics_workspace" "main" {
  name                = var.aks_log_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
}