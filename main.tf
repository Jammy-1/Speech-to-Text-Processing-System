# Resource Group
module "resource_group" {
  source              = "./modules/resource-group"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# Storage
module "storage" {
  source              = "./modules/storage"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  storage_account_name = var.storage_account_name
}

# Key Vault
module "key-vault" {
  source              = "./modules/key-vault"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  key_vault_name = var.key_vault_name
  tenant_id      = var.tenant_id

  # ACR
  acr_encryption_key_name = var.acr_encryption_key_name

  # Speech 
  speech_key_name    = var.speech_key_name
  speech_primary_key = module.cognitive.speech_primary_key

  # Search
  search_key_name    = var.search_key_name
  search_primary_key = module.cognitive.search_primary_key

  # AKS
  aks_principal_id = module.aks.aks_principal_id
}

# Network
module "network" {
  source              = "./modules/network"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  # VNet
  vnet_name = var.vnet_name

  # NSG
  nsg_name_aks        = var.nsg_name_aks
  nsg_name_ingress    = var.nsg_name_ingress
  nsg_name_pe         = var.nsg_name_pe
  nsg_name_queue      = var.nsg_name_queue
  nsg_name_monitoring = var.nsg_name_queue

  # Subnt
  subnet_name_aks        = var.subnet_name_aks
  subnet_name_ingress    = var.subnet_name_ingress
  subnet_name_pe         = var.subnet_name_pe
  subnet_name_queue      = var.subnet_name_pe
  subnet_name_monitoring = var.subnet_name_pe

  # Storage DNS Link
  storage_dns_link_name = var.storage_dns_link_name
  speech_dns_link_name  = var.speech_dns_link_name
  search_dns_link_name  = var.search_dns_link_name
  queue_dns_link_name   = var.queue_dns_link_name

  # Storage DNS Group
  storage_dns_group_name = var.storage_dns_group_name
  speech_dns_group_name  = var.speech_dns_group_name
  search_dns_group_name  = var.search_dns_group_name
  queue_dns_group_name   = var.queue_dns_group_name


  # Private Endpoint
  private_endpoint_name_storage_pe = var.private_endpoint_name_storage_pe
  private_endpoint_name_speech_pe  = var.private_endpoint_name_speech_pe
  private_endpoint_name_search_pe  = var.private_endpoint_name_search_pe
  private_endpoint_name_queue_pe   = var.private_endpoint_name_queue_pe

  # Application Gateway 
  app_gw_name                     = var.app_gw_name
  app_gw_ip_config_name           = var.app_gw_ip_config_name
  app_gw_frontend_ip_config_name  = var.app_gw_frontend_ip_config_name
  app_gw_aks_backend_pool_ip_name = var.app_gw_aks_backend_pool_ip_name

  # Public IP
  public_ip_app_gw_name   = var.public_ip_app_gw_name
  public_ip_frontend_name = var.public_ip_frontend_name

  # Security Rules
  security_rules_aks     = var.security_rules_aks
  security_rules_ingress = var.security_rules_ingress

  # Storage 
  storage_account_id = module.storage.storage_account_id

  # ID's
  speech_id      = module.cognitive.speech_id
  search_id      = module.cognitive.speech_id
  service_bus_id = module.queue.service_bus_id
}

# ACR
module "acr" {
  source              = "./modules/acr"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  acr_name     = var.acr_name
  uai_acr_name = var.acr_name

  # Access
  key_vault_id            = module.key-vault.acr_encryption_key_id
  acr_encryption_key_name = var.acr_encryption_key_name
  acr_id                  = module.acr.acr_id
  aks_uai_principal_id    = module.aks.aks_principal_id
  uai_ci_cd_name          = var.uai_ci_cd_name

}

# K8
module "k8" {
  source                = "./modules/kubernetes"
  location              = var.location
  k8_environment        = var.k8_environment
  k8_label_project_name = var.k8_label_project_name


  # Provider
  kube_host                   = module.aks.kube_host
  kube_client_certificate     = module.aks.kube_client_certificate
  kube_client_key             = module.aks.kube_client_key
  kube_cluster_ca_certificate = module.aks.kube_cluster_ca_certificate

  # Cognitive 
  cognitive_account_name = var.cognitive_account_name
  search_index_name      = module.cognitive.transcripts_index_name

  # Speech
  speech_key      = module.cognitive.speech_primary_key

  # Search

  # Storage 
  storage_account_name       = var.storage_account_name
  transcripts_container_name = module.storage.transcripts_container_name

  # Queue
  service_bus_name      = var.service_bus
  search_service_name   = var.search_service_name
  service_bus_namespace = module.queue.service_bus_namespace

  search_queue  = var.search_queue
  speech_queue  = var.speech_queue
  storage_queue = var.storage_queue

  # Worker Images
  api_worker_image     = var.api_worker_image
  speech_worker_image  = var.speech_worker_image
  search_worker_image  = var.search_worker_image
  storage_worker_image = var.storage_worker_image

  tags = var.tags
}

# AKS
module "aks" {
  source              = "./modules/aks"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  kubernetes_cluster_name = var.kubernetes_cluster_name
  uai_aks_name            = var.uai_aks_name

  # Network
  aks_dns       = var.aks_dns
  aks_subnet_id = module.network.aks_subnet_id

  # AKS Parameters
  aks_node_pool_name     = var.aks_node_pool_name
  aks_node_scaling_min   = var.aks_node_scaling_min
  aks_node_scaling_max   = var.aks_node_scaling_max
  aks_node_size          = var.aks_node_size
  aks_log_workspace_name = var.aks_log_workspace_name
  acr_id                 = module.acr.acr_id

  # Access
  key_vault_id               = module.key-vault.key_vault_id
  rbac_aks_speech_key_access = module.key-vault.speech_secret_id
  rbac_aks_search_key_access = module.key-vault.search_secret_id
}

# Cognitive
module "cognitive" {
  source              = "./modules/cognitive"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  cognitive_account_name = var.cognitive_account_name
  search_service_name    = var.search_service_name

  # Access
  key_vault_id               = module.key-vault.key_vault_id
  uai_name_search_service    = var.uai_name_search_service
  uai_name_cognitive_account = var.uai_name_cognitive_account
}

# Queue
module "queue" {
  source              = "./modules/queue"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  # Names
  speech_queue_name  = var.speech_queue
  search_queue_name  = var.search_queue
  storage_queue_name = var.storage_queue

  # Access
  service_bus_name     = var.service_bus
  aks_uai_principal_id = module.aks.aks_principal_id

}

