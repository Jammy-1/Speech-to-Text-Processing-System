# General
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "tags" { type = map(string) }

# Cognitive Speehc
variable "cognitive_account_name" { type = string }
variable "uai_name_cognitive_account" { type = string }

# Search 
variable "search_service_name" { type = string }

variable "uai_search_service_name" { type = string }
variable "uai_search_worker_name" { type = string }

# Queue / Service Bus
variable "service_bus" { type = string }
variable "speech_queue" { type = string }
variable "search_queue" { type = string }
variable "storage_queue" { type = string }
variable "service_bus_encryption_key_name" { type = string }

# Storage 
variable "storage_account_name" { type = string }
variable "storage_log_name" { type = string }
variable "uai_speech_worker_name" { type = string }

# Log Analytics
variable "log_workspace_name" { type = string }

# ACR
variable "acr_name" {}
variable "uai_acr_encryption_name" { type = string }
variable "uai_ci_cd_acr_name" { type = string }

# AKS
variable "kubernetes_cluster_name" { type = string }
variable "aks_dns" { type = string }
variable "aks_node_pool_name" { type = string }

variable "aks_disk_encryption_key_name" { type = string }

variable "aks_node_scaling_min" { type = number }
variable "aks_node_scaling_max" { type = number }
variable "aks_node_os_disk_size" { type = string }

variable "aks_node_size" { type = string }
variable "uai_aks_name" { type = string }

# K8
variable "k8_environment" { type = string }
variable "k8_label_project_name" { type = string }

# K8 - Config Map 
variable "search_index_name" { type = string }
variable "audio_container_name" { type = string }
variable "transcripts_container_name" { type = string }

# K8 - Deployment
variable "api_worker_image" { type = string }
variable "speech_worker_image" { type = string }
variable "search_worker_image" { type = string }
variable "storage_worker_image" { type = string }

# K8 - Storage
variable "uai_storage_worker_name" { type = string }

# K8 - API 
variable "uai_api_worker_name" { type = string }

# Key Vault
variable "key_vault_name" { type = string }
variable "uai_ci_cd_kv_admin_name" { type = string }

variable "acr_encryption_key_name" { type = string }

# Key Vault - Speech Key 
variable "speech_key_name" { type = string }

# Key Vault - Search key
variable "search_key_name" { type = string }

# Vnet
variable "vnet_name" {}

# Subnet
variable "subnet_name_aks" { type = string }
variable "subnet_name_ingress" { type = string }
variable "subnet_name_pe" { type = string }
variable "subnet_name_queue" { type = string }
variable "subnet_name_monitoring" { type = string }
variable "subnet_name_acr" { type = string }

# Application Gateway
variable "app_gw_name" { type = string }
variable "app_gw_ip_config_name" { type = string }
variable "app_gw_frontend_ip_config_name" { type = string }
variable "app_gw_aks_backend_pool_ip_name" { type = string }

# Public Ip
variable "public_ip_frontend_name" { type = string }
variable "public_ip_app_gw_name" { type = string }

# Private Endpoint
variable "private_endpoint_name_storage_pe" { type = string }
variable "private_endpoint_name_speech_pe" { type = string }
variable "private_endpoint_name_search_pe" { type = string }
variable "private_endpoint_name_queue_pe" { type = string }
variable "private_endpoint_name_acr_pe" { type = string }

# DNS
variable "storage_dns_link_name" { type = string }
variable "speech_dns_link_name" { type = string }
variable "search_dns_link_name" { type = string }
variable "storage_dns_group_name" { type = string }
variable "queue_dns_link_name" { type = string }
variable "acr_dns_link_name" { type = string }

variable "speech_dns_group_name" { type = string }
variable "search_dns_group_name" { type = string }
variable "queue_dns_group_name" { type = string }
variable "acr_dns_group_name" { type = string }

# NSG
variable "nsg_name_aks" { type = string }
variable "nsg_name_ingress" { type = string }
variable "nsg_name_pe" { type = string }
variable "nsg_name_queue" { type = string }
variable "nsg_name_monitoring" { type = string }

# NSG Rules - AKS
variable "security_rules_aks" {
  type = list(object({
    name                                       = string
    priority                                   = number
    direction                                  = string
    access                                     = string
    protocol                                   = string
    source_port_range                          = optional(string)
    source_port_ranges                         = optional(list(string))
    destination_port_range                     = optional(string)
    destination_port_ranges                    = optional(list(string))
    source_address_prefix                      = optional(string)
    source_address_prefixes                    = optional(list(string))
    source_application_security_group_ids      = optional(list(string))
    destination_address_prefix                 = optional(string)
    destination_address_prefixes               = optional(list(string))
    destination_application_security_group_ids = optional(list(string))
  }))
}

# NSG Rules - Ingress 
variable "security_rules_ingress" {
  type = list(object({
    name                                       = string
    priority                                   = number
    direction                                  = string
    access                                     = string
    protocol                                   = string
    source_port_range                          = optional(string)
    source_port_ranges                         = optional(list(string))
    destination_port_range                     = optional(string)
    destination_port_ranges                    = optional(list(string))
    source_address_prefix                      = optional(string)
    source_address_prefixes                    = optional(list(string))
    source_application_security_group_ids      = optional(list(string))
    destination_address_prefix                 = optional(string)
    destination_address_prefixes               = optional(list(string))
    destination_application_security_group_ids = optional(list(string))
  }))
}