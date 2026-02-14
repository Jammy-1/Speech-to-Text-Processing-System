# UAI & RBAC For Key Vault - modules\key-vault\key_vault.tf

# UAI - CI/CD - KV Admin
resource "azurerm_user_assigned_identity" "ci_cd_uai_kv_admin" {
  name                = var.uai_ci_cd_kv_admin_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# RBAC - CI/CD - KV Admin
resource "azurerm_role_assignment" "rbac_ci_cd_kv_admin" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Administrator"
  principal_id         = azurerm_user_assigned_identity.ci_cd_uai_kv_admin.principal_id

  depends_on = [azurerm_user_assigned_identity.ci_cd_uai_kv_admin]
}

