# General
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "tags" { type = map(string) }

# Key Vault
variable "key_vault_name" { type = string }
variable "tenant_id" { type = string }
variable "uai_ci_cd_kv_admin_name" { type = string }

# Network
variable "pe_subnet_id" { type = string }

# ACR
variable "acr_encryption_key_name" { type = string }

# Service Bus
variable "servicebus_encryption_key_name" { type = string }

# AKS
variable "aks_principal_id" { type = string }
variable "aks_disk_encryption_key_name" { type = string }

# Speech Key 
variable "speech_key_name" { type = string }
variable "speech_primary_key" {
  type      = string
  sensitive = true
}

# Search Key
variable "search_key_name" { type = string }
variable "search_primary_key" {
  type      = string
  sensitive = true
}
