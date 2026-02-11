# General
variable "resource_group_name" {}
variable "location" {}
variable "tags" { type = map(string) }

# ACR
variable "acr_name" {}

# UAI
variable "uai_acr_name" { type = string }
variable "uai_acr_encryption_id" { type = string }
variable "uai_acr_encryption_client_id" { type = string }

# AKS
variable "aks_uai_principal_id" { type = string }

# Key Vault
variable "acr_encryption_key_id" { type = string }