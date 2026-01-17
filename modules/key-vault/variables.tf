# General
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "tags" { type = map(string) }

# Key Vault
variable "key_vault_name" { type = string }
variable "tenant_id" { type = string }

# ACR
variable "acr_encryption_key_name" { type = string }
variable "acr_id" { type = string }

# Speech Key 
variable "speech_key_name" { type = string }
variable "speech_key" { type = string }

# AKS
variable "aks_principal_id" { type = string }