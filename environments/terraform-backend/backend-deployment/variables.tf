# General 
variable "state_resource_group_name" { type = string }
variable "location" { type = string }
variable "tags" { type = map(string) }

# Backend 
variable "state_storage_account_name" { type = string }
variable "state_storage_container_name" { type = string }
variable "state_blob_name" { type = string }

variable "state_key_backend" { type = string }
variable "state_key_deployment" { type = string }

variable "backend_tags" { type = map(string) }
