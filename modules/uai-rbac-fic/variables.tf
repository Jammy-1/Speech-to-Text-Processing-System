# General
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "tags" { type = map(string) }

# Storage 
variable "uai_storage_worker_name" { type = string }
variable "audio_container_id" { type = string }
variable "transcripts_container_id" { type = string }

# Speech
variable "speech_id" { type = string }
variable "uai_name_cognitive_account" { type = string }
variable "uai_speech_worker_name" { type = string }

# Search 
variable "uai_search_service_name" { type = string }
variable "search_service_id" { type = string }
variable "uai_search_worker_name" { type = string }

# API 
variable "uai_api_worker_name" { type = string }

# Queue
variable "service_bus_id" { type = string }
variable "service_bus_namespace_id" { type = string }

# AKS
variable "aks_oidc" { type = string }
variable "uai_aks_name" { type = string }
variable "disk_encryption_set_id" { type = string }
variable "aks_subnet_id" { type = string }

# ACR
variable "uai_acr_encryption_name" { type = string }
variable "acr_encryption_key_id" { type = string }
variable "uai_ci_cd_acr_name" { type = string }
variable "acr_id" { type = string }

# Key Vault
variable "key_vault_id" { type = string }
variable "uai_ci_cd_kv_admin_name" { type = string }