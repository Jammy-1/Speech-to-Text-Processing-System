# General
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "tags" { type = map(string) }

# Logs Analytics
variable "storage_log_name" { type = string }
variable "log_workspace_id" { type = string }

# Storage 
variable "storage_account_name" { type = string }

# Subnet 
variable "pe_subnet_id" { type = string }