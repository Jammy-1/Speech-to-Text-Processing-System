# General
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "tags" { type = map(string) }

# Key Vault
variable "key_vault_name" { type = string }

# Network
variable "pe_subnet_id" { type = string }

# AKS
variable "aks_principal_id" { type = string }

# Speech  
variable "speech_name" { type = string }
variable "speech_key_name" { type = string }

# Search 
variable "search_name" { type = string }
variable "search_key_name" { type = string }

