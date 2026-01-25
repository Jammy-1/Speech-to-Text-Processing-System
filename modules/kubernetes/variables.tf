# General
variable "tags" { type = map(string) }

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

# Storage 
variable "storage_account_name" { type = string }
variable "storage_queue_name" { type = string }

# Cognitive
variable "search_service_name" { type = string }

# Service Bus 
variable "service_bus_name" { type = string }

# Speech 
variable "speech_key_name" { type = string }
variable "speech_queue_name" { type = string }

# Search 
variable "search_queue_name" { type = string }

