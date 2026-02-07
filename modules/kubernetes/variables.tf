# General
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "tags" { type = map(string) }
variable "k8_environment" { type = string }
variable "k8_label_project_name" { type = string }

# Config Map 
variable "cognitive_account_name" { type = string }
variable "search_index_name" { type = string }
variable "transcripts_container_name" { type = string }

# Deployment
variable "speech_worker_image" { type = string }
variable "api_worker_image" { type = string }
variable "search_worker_image" { type = string }
variable "storage_worker_image" { type = string }

# Provider
variable "kube_host" { type = string }
variable "kube_client_certificate" { type = string }
variable "kube_client_key" { type = string }
variable "kube_cluster_ca_certificate" { type = string }

# API 
variable "uai_name_api" { type = string }

# Storage 
variable "storage_account_name" { type = string }
variable "storage_queue" { type = string }

# Cognitive
variable "search_service_name" { type = string }

# Service Bus 
variable "service_bus_name" { type = string }
variable "service_bus_namespace" { type = string }

# Speech 
variable "speech_key" { type = string }
variable "speech_queue" { type = string }
variable "speech_queue_id" { type = string }

# Search 
variable "search_queue" { type = string }

# AKs
variable "aks_oidc" { type = string }
