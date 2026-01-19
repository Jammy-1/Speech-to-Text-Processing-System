# General
variable "resource_group_name" {}
variable "location" {}
variable "tags" { type = map(string) }

# ACR
variable "acr_name" {}
variable "uai_acr_name" { type = string }
variable "key_vault_id" { type = string }


# AKS
variable "aks_uai_principal_id" { type = string }

# ACR
variable "acr_encryption_key_name" { type = string }
variable "acr_id" { type = string }
