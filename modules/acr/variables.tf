# General
variable "resource_group_name" {}
variable "location" {}
variable "tags" { type = map(string) }

# ACR
variable "acr_name" {}
variable "acr_encryption_key_name" { type = string }
variable "acr_id" { type = string }

variable "uai_acr_name" { type = string }
variable "uai_ci_cd_name" { type = string }

# AKS
variable "aks_uai_principal_id" { type = string }

# Key Vault
variable "key_vault_id" { type = string }

# Worker Images
variable "speech_worker_image" { type = string }
variable "search_worker_image" { type = string }
variable "storage_worker_image" { type = string }
variable "api_image" { type = string }
