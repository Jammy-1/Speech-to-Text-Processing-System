# General
variable "resource_group_name" {}
variable "location" {}
variable "tags" { type = map(string) }

# ACR
variable "acr_name" {}
variable "uai_acr_name" { type = string }
variable "key_vault_id" { type = string }