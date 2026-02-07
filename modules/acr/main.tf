# ACR
resource "azurerm_container_registry" "main" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  sku                           = "Premium"
  admin_enabled                 = false
  public_network_access_enabled = true

  retention_policy_in_days  = 30
  quarantine_policy_enabled = true
  trust_policy_enabled      = true


  network_rule_bypass_option = "AzureServices"
  network_rule_set { default_action = "Deny" }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.acr_uai.id]
  }

  encryption {
    key_vault_key_id   = var.acr_encryption_key_id
    identity_client_id = azurerm_user_assigned_identity.acr_uai.client_id
  }

  georeplications {
    location                = "ukwest"
    zone_redundancy_enabled = true
    tags                    = var.tags
  }
}

# UAI - ACR
resource "azurerm_user_assigned_identity" "acr_uai" {
  name                = var.uai_acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# UAI - CI/CD
resource "azurerm_user_assigned_identity" "ci_cd_uai_acr" {
  name                = var.uai_ci_cd_acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# RBAC - ACR UAI - Access Encryption Key
resource "azurerm_role_assignment" "rbac_acr_encrypt_key_access" {
  scope                = var.acr_encryption_key_id
  role_definition_name = "Key Vault Crypto User"
  principal_id         = azurerm_user_assigned_identity.acr_uai.principal_id
}

# RBAC - AKS Pull ACR Container
resource "azurerm_role_assignment" "rbac_aks_acr_pull" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = var.aks_uai_principal_id
}

# RBAC - CI/CD - ACR Push
resource "azurerm_role_assignment" "rbac_ci_cd_acr" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPush"
  principal_id         = azurerm_user_assigned_identity.ci_cd_uai_acr.principal_id
}