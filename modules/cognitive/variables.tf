# General
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "tags" { type = map(string) }

# Cognitive
variable "cognitive_account_name" { type = string }
variable "search_service_name" { type = string }

# UAI
variable "uai_name_cognitive_account" { type = string }
variable "uai_name_search_service" { type = string }

# Key Vault
variable "key_vault_id" { type = string }
