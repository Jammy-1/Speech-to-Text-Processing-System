# ACR UAI, RBAC & FIC - modules\acr\

# UAI - ACR - Encryption 
resource "azurerm_user_assigned_identity" "uai_acr_encryption" {
  name                = var.uai_acr_encryption_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# RBAC - ACR UAI - Access Encryption Key
resource "azurerm_role_assignment" "rbac_acr_encrypt_key_access" {
  scope                = var.acr_encryption_key_id
  role_definition_name = "Key Vault Crypto User"
  principal_id         = azurerm_user_assigned_identity.uai_acr_encryption.principal_id
}

# UAI - CI/CD - Push Images
resource "azurerm_user_assigned_identity" "uai_ci_cd_acr_push" {
  name                = var.uai_ci_cd_acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# RBAC - CI/CD - ACR Push
resource "azurerm_role_assignment" "rbac_ci_cd_acr" {
  scope                = var.acr_id
  role_definition_name = "AcrPush"
  principal_id         = azurerm_user_assigned_identity.uai_ci_cd_acr_push.principal_id
}