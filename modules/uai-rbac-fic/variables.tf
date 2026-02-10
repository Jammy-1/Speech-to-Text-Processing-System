# General
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "tags" { type = map(string) }

# Storage 
variable "audio_container_id" { type = string }
variable "transcripts_container_id" { type = string }

# Speech
variable "speech_id" { type = string }
variable "uai_speech_worker_name" { type = string }

# API 
variable "uai_api_worker_name" { type = string }
variable "k8_api_sa" { type = string }

# Queue
variable "service_bus_id" { type = string }
variable "service_bus_namespace_id" { type = string }

# AKS
variable "aks_oidc" { type = string }