# General
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "tags" { type = map(string) }

# Speech 
variable "cognitive_account_name" { type = string }
variable "cognitive_account_uai_id" { type = string }

# Search
variable "search_service_name" { type = string }
variable "search_service_uai_id" { type = string }

# Key Vault
variable "key_vault_id" { type = string }

# Subnet 
variable "pe_subnet_id" { type = string }

