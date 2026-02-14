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
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  tags                = var.tags

  storage_account_name = var.storage_account_name

  # Network
  pe_subnet_id = module.network.pe_subnet_id

  # Logs
  log_workspace_id = module.log-analytics.log_analytics_workspace_id
  storage_log_name = var.storage_log_name
}

# Cognitive - Speech & Search
module "cognitive" {
  source              = "./modules/cognitive"
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  tags                = var.tags

  # Speech
  cognitive_account_name = var.cognitive_account_name

  #Search
  search_service_name   = var.search_service_name
  search_service_uai_id = module.uai-rbac-fic.uai_search_service_id

  # Subnet 
  pe_subnet_id = module.network.pe_subnet_id

  # Access
  key_vault_id = module.key-vault.key_vault_id
  uai_name_cognitive_account = var.uai_name_cognitive_account
  depends_on = [module.resource_group]
}

# ACR
module "acr" {
  source              = "./modules/acr"
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  tags                = var.tags

  acr_name     = var.acr_name
  uai_acr_name = var.acr_name

  # UAI- RBAC 
  uai_acr_encryption_client_id = module.uai-rbac-fic.uai_acr_encryption_client_id
  uai_acr_encryption_id        = module.uai-rbac-fic.uai_acr_encryption_id
  acr_encryption_key_id        = module.key-vault.acr_encryption_key_id
  aks_uai_principal_id         = module.uai-rbac-fic.uai_aks_principal_id
}

# AKS
module "aks" {
  source              = "./modules/aks"
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  tags                = var.tags

  kubernetes_cluster_name = var.kubernetes_cluster_name
  uai_aks_id              = module.uai-rbac-fic.uai_aks_id

  # Network
  aks_dns       = var.aks_dns
  aks_subnet_id = module.network.aks_subnet_id

  # AKS Parameters
  aks_node_pool_name     = var.aks_node_pool_name
  aks_node_scaling_min   = var.aks_node_scaling_min
  aks_node_scaling_max   = var.aks_node_scaling_max
  aks_node_size          = var.aks_node_size
  aks_node_os_disk_size  = var.aks_node_os_disk_size
  log_workspace_id       = module.log-analytics.log_analytics_workspace_id
  disk_encryption_set_id = module.key-vault.aks_disk_encryption_key_id
  acr_id                 = module.acr.acr_id
}

# UAI - RBAC - FIC
module "uai-rbac-fic" {
  source              = "./modules/uai-rbac-fic"
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  tags                = var.tags

  # API
  uai_api_worker_name      = var.uai_api_worker_name
  service_bus_namespace_id = module.queue.service_bus_id
  aks_oidc                 = module.aks.aks_oidc

  # ACR 
  uai_acr_encryption_name = var.uai_acr_encryption_name
  uai_ci_cd_acr_name      = var.uai_ci_cd_acr_name
  acr_encryption_key_id   = module.key-vault.acr_encryption_key_id
  acr_id                  = module.acr.acr_id

  # AKS
  uai_aks_name           = var.uai_aks_name
  disk_encryption_set_id = module.key-vault.aks_disk_encryption_key_id
  aks_subnet_id          = module.network.aks_subnet_id

  # Storage
  audio_container_id       = module.storage.audio_container_id
  transcripts_container_id = module.storage.transcripts_container_id
  uai_storage_worker_name  = var.uai_storage_worker_name

  # Speech
  speech_id              = module.cognitive.speech_id
  uai_speech_worker_name = var.uai_speech_worker_name

  # Search
  uai_search_service_name = var.search_service_name
  uai_search_worker_name  = var.uai_search_worker_name
  search_service_id       = module.cognitive.search_id
  key_vault_id            = module.key-vault.key_vault_id

  # Queue
  service_bus_id = module.queue.service_bus_id

  depends_on = [ module.resource_group ]
}

# Key Vault
module "key-vault" {
  source              = "./modules/key-vault"
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  tags                = var.tags

  key_vault_name = var.key_vault_name
  tenant_id      = var.tenant_id

  # ServiceBus
  servicebus_encryption_key_name = var.service_bus_encryption_key_name

  #Network
  pe_subnet_id = module.network.pe_subnet_id

  # UAI
  uai_ci_cd_kv_admin_name = var.uai_ci_cd_kv_admin_name

  # ACR
  acr_encryption_key_name = var.acr_encryption_key_name

  # Speech 
  speech_key_name    = var.speech_key_name
  speech_primary_key = module.cognitive.speech_primary_key

  # Search
  search_key_name    = var.search_key_name
  search_primary_key = module.cognitive.search_primary_key

  # AKS
  aks_principal_id             = module.uai-rbac-fic.uai_aks_principal_id
  aks_disk_encryption_key_name = var.acr_encryption_key_name

  depends_on = [module.resource_group]
}

# Queue
module "queue" {
  source              = "./modules/queue"
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  tags                = var.tags

  key_vault_id = module.key-vault.key_vault_id

  # Names
  speech_queue_name  = var.speech_queue
  search_queue_name  = var.search_queue
  storage_queue_name = var.storage_queue

  # Service Bus 
  service_bus_name              = var.service_bus
  service_bus_encryption_key_id = module.key-vault.service_bus_encryption_key_id

  # AKS
  aks_uai_principal_id = module.uai-rbac-fic.uai_aks_principal_id

  depends_on = [module.resource_group]
}

module "log-analytics" {
  source              = "./modules/log-analytics"
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  tags                = var.tags

  log_workspace_name = var.log_workspace_name
}

# K8
module "k8" {
  source                = "./modules/kubernetes"
  resource_group_name   = module.resource_group.resource_group_name
  location              = var.location
  k8_environment        = var.k8_environment
  k8_label_project_name = var.k8_label_project_name

  # API
  uai_api_worker_client_id = module.uai-rbac-fic.uai_api_worker_client_id

  # Provider
  kube_host                   = module.aks.kube_host
  kube_client_certificate     = module.aks.kube_client_certificate
  kube_client_key             = module.aks.kube_client_key
  kube_cluster_ca_certificate = module.aks.kube_cluster_ca_certificate

  # Cognitive 
  cognitive_account_name = var.cognitive_account_name
  search_index_name      = module.cognitive.transcripts_index_name

  # Speech
  speech_key             = module.cognitive.speech_primary_key
  speech_queue_id        = module.cognitive.speech_id
  uai_speech_worker_name = var.uai_speech_worker_name

  # Search
  uai_search_worker_name = var.uai_search_service_name

  # Storage 
  storage_account_name       = var.storage_account_name
  audio_container_name       = var.audio_container_name
  transcripts_container_name = module.storage.transcripts_container_name
  uai_storage_worker_name    = var.uai_storage_worker_name

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

# Network
module "network" {
  source              = "./modules/network"
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  tags                = var.tags

  # ACR
  acr_id = module.acr.acr_id

  # VNet
  vnet_name = var.vnet_name

  # NSG
  nsg_name_aks        = var.nsg_name_aks
  nsg_name_ingress    = var.nsg_name_ingress
  nsg_name_pe         = var.nsg_name_pe
  nsg_name_queue      = var.nsg_name_queue
  nsg_name_monitoring = var.nsg_name_monitoring

  # Subnt
  subnet_name_aks        = var.subnet_name_aks
  subnet_name_ingress    = var.subnet_name_ingress
  subnet_name_pe         = var.subnet_name_pe
  subnet_name_queue      = var.subnet_name_queue
  subnet_name_monitoring = var.subnet_name_monitoring
  subnet_name_acr        = var.subnet_name_acr

  # Storage DNS Link
  storage_dns_link_name = var.storage_dns_link_name
  speech_dns_link_name  = var.speech_dns_link_name
  search_dns_link_name  = var.search_dns_link_name
  queue_dns_link_name   = var.queue_dns_link_name
  acr_dns_link_name     = var.acr_dns_link_name

  # Storage DNS Group
  storage_dns_group_name = var.storage_dns_group_name
  speech_dns_group_name  = var.speech_dns_group_name
  search_dns_group_name  = var.search_dns_group_name
  queue_dns_group_name   = var.queue_dns_group_name
  acr_dns_group_name     = var.acr_dns_group_name

  # Private Endpoint
  private_endpoint_name_storage_pe = var.private_endpoint_name_storage_pe
  private_endpoint_name_speech_pe  = var.private_endpoint_name_speech_pe
  private_endpoint_name_search_pe  = var.private_endpoint_name_search_pe
  private_endpoint_name_queue_pe   = var.private_endpoint_name_queue_pe
  private_endpoint_name_acr_pe     = var.private_endpoint_name_acr_pe

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
  search_id      = module.cognitive.search_id
  service_bus_id = module.queue.service_bus_id

  depends_on = [module.resource_group]
}