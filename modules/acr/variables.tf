# General
variable "resource_group_name" {}
variable "location" {}
variable "tags" { type = map(string) }

# ACR
variable "acr_name" {}
variable "acr_encryption_key_name" { type = string }

# UAI
variable "uai_acr_name" { type = string }
variable "uai_ci_cd_acr_name" { type = string }

# AKS
variable "aks_uai_principal_id" { type = string }

# Key Vault
variable "acr_encryption_key_id" { type = string }