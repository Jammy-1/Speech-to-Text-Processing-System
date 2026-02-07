# General
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "tags" { type = map(string) }

# AKS
variable "kubernetes_cluster_name" { type = string }

variable "aks_dns" { type = string }
variable "aks_subnet_id" {}

variable "aks_node_pool_name" { type = string }
variable "aks_node_scaling_min" { type = number }
variable "aks_node_scaling_max" { type = number }
variable "aks_node_size" { type = string }
variable "aks_node_os_disk_size" { type = string }

# Log Workspace
variable "log_workspace_id" { type = string }

# UAI
variable "uai_aks_name" { type = string }

# Key Vault
variable "key_vault_id" { type = string }
variable "rbac_aks_speech_key_access" { type = string }
variable "rbac_aks_search_key_access" { type = string }
variable "disk_encryption_set_id" { type = string }

# ACR
variable "acr_id" { type = string }

