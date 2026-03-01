# General
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "tags" { type = map(string) }

# Log Analytics
variable "log_workspace_name" { type = string }

# Storage 
variable "storage_log_name" { type = string }
variable "storage_account_id" { type = string }