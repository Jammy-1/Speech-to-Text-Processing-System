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

variable "aks_log_workspace_name" { type = string }

# UAI
variable "uai_aks_name" { type = string }

# ACR
variable "acr_id" { type = string }
