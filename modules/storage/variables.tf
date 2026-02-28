# General
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "tags" { type = map(string) }

# Storage 
variable "storage_account_name" { type = string }

# Subnet 
variable "pe_subnet_id" { type = string }