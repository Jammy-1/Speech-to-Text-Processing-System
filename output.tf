# Resource Group
output "resource_group_name" { value = module.resource_group.resource_group_name }

# Storage
output "storage_account_name" { value = module.storage.storage_account_name }

# Queue
output "service_bus_namespace" { value = module.queue.service_bus_namespace }
output "speech_queue_name" { value = module.queue.speech_queue_name }
output "search_queue_name" { value = module.queue.search_queue_name }
output "storage_queue_name" { value = module.queue.storage_queue_name }

# AKS
output "aks_cluster_name" { value = module.aks.aks_cluster_name }

# Cognitive
output "cognitive_search_name" { value = module.cognitive.search_name }
output "cognitive_speech_name" { value = module.cognitive.speech_name }


# Network
output "vnet_name" { value = module.network.vnet_name }

output "aks_subnet_address_prefixes" { value = module.network.aks_subnet_address_prefixes }
output "acr_subnet_address_prefixes" { value = module.network.acr_subnet_address_prefixes }
output "ingress_subnet_address_prefixes" { value = module.network.ingress_subnet_address_prefixes }
output "monitoring_subnet_address_prefixes" { value = module.network.monitoring_subnet_address_prefixes }
output "queue_subnet_address_prefixes" { value = module.network.queue_subnet_address_prefixes }
output "pe_subnet_address_prefixes" { value = module.network.pe_subnet_address_prefixes }