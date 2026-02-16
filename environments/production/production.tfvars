# Production TFVARS

# General
resource_group_name = "Speech-to-Text-Processing-System-Production"
location            = "UKSOUTH"

# Tags
tags = {
  Project     = "Speech-to-Text-Processing-System-Production"
  Environment = "Production"
  Owner       = "dev-ops"
  CostCenter  = "Speech-to-Text-Processing-System-Production"
  ManagedBy   = "dev-ops"
  CreatedDate = "2026-02-16"
}

# Storage
storage_account_name    = "sttprocessingprod"
uai_storage_worker_name = "uai-storage-worker"


# Log Analytics
log_workspace_name = "stt-log-analytics-prod"
storage_log_name   = "storage-logs-stt-prod"

# Key Vault
key_vault_name          = "kv-stt-prod"
acr_encryption_key_name = "stt-acr-encrypt-key"
uai_ci_cd_kv_admin_name = "kv-admin-uai"


speech_key_name = "stt-speech-kv-key"
search_key_name = "stt-search-key"

# Cognitive: 

#Speech
cognitive_account_name     = "stt-cognitive-search-prod"
uai_name_cognitive_account = "uai-ca-speech-service"
uai_speech_worker_name     = "uai-speech-worker"

# Search
search_service_name     = "search-service-stt-prod"
uai_search_service_name = "uai-search-service"
uai_search_worker_name  = "uai-search-worker"


search_index_name          = "stt-transcripts-index"
audio_container_name       = "audio-container"
transcripts_container_name = "transcripts-container"

# Queue / Service Bus
service_bus                     = "stt-aks-service-bus-prod"
speech_queue                    = "stt-speech-queue"
search_queue                    = "stt-search-queue"
storage_queue                   = "stt-storage-queue"
service_bus_encryption_key_name = "stt-sb-disk-encrypt-key"

# ACR 
acr_name                = "acrsttprocessingprod"
uai_acr_encryption_name = "uai-acr-encryption"
uai_ci_cd_acr_name      = "ci-cd-acr-uai"
api_worker_image        = "myacrprod.azurecr.io/api:prod"
speech_worker_image     = "myacrprod.azurecr.io/speech-worker:prod"
search_worker_image     = "myacrprod.azurecr.io/search-worker:prod"
storage_worker_image    = "myacrprod.azurecr.io/storage-worker:prod"

# AKS
kubernetes_cluster_name = "stt-aks-cluster-prod"
uai_aks_name            = "aks-uai-sttprocessing"

aks_dns                      = "sttaksdns"
aks_node_pool_name           = "aksnodepool"
aks_node_scaling_min         = 1
aks_node_scaling_max         = 3
aks_node_size                = "standard_b2s"
aks_node_os_disk_size        = 20
aks_disk_encryption_key_name = "stt-aks-disk-encrypt-key"

# K8's
k8_environment        = "dev"
k8_label_project_name = "Speech-to-Text-Processing-System"

uai_api_worker_name = "uai-ca-speech-service-worker"

# Vnet
vnet_name = "stt-vnet-prod"

# NSG
nsg_name_aks        = "stt-aks-nsg"
nsg_name_ingress    = "stt-ingress-nsg"
nsg_name_pe         = "stt-pe-nsg"
nsg_name_queue      = "stt-queue-nsg"
nsg_name_monitoring = "stt-monitoring-nsg"

# Subnet
subnet_name_aks        = "aks-subnet"
subnet_name_ingress    = "ingress-subnet"
subnet_name_pe         = "private-endpoint-subnet"
subnet_name_queue      = "message-queue-subnet"
subnet_name_monitoring = "monitoring-subnet"
subnet_name_acr        = "monitoring-subnet"

# Private Endpoint
private_endpoint_name_storage_pe = "stt-storage-pe"
private_endpoint_name_speech_pe  = "stt-speech-pe"
private_endpoint_name_search_pe  = "stt-speech-pe"
private_endpoint_name_queue_pe   = "stt-queue-pe"
private_endpoint_name_acr_pe     = "stt-acr-pe"

# DNS 
storage_dns_link_name  = "storage-dns-link"
speech_dns_link_name   = "speech-dns-link"
search_dns_link_name   = "search-dns-link"
queue_dns_link_name    = "queue-dns-link"
acr_dns_link_name      = "acr-dns-link"
storage_dns_group_name = "storage-dns"
speech_dns_group_name  = "speech-dns"
search_dns_group_name  = "search-dns"
queue_dns_group_name   = "queue-dns"
acr_dns_group_name     = "acr-dns"


# Application Gateway
app_gw_name                     = "app-gw-http-prod"
app_gw_ip_config_name           = "appgw-ip-cfg"
app_gw_frontend_ip_config_name  = "app-gw-frontend-ip"
app_gw_aks_backend_pool_ip_name = "aks-backend-pool"

# Public Ip
public_ip_frontend_name = "public-ip-frontend"
public_ip_app_gw_name   = "public-ip-app-gw"

# NSG Rules - AKS
security_rules_aks = [
  {
    name                       = "Allow-AppGW-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "10.0.2.0/24"
    destination_address_prefix = "10.0.1.0/24"
  },
  {
    name                       = "Allow-Kube-NodeCommunication"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = ["10250", "10255", "443", "30000-32767"]
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "10.0.1.0/24"
  },
  {
    name                       = "Allow-AzureCloud-Out"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "AzureCloud"
  },
  {
    name                       = "Allow-KeyVault-Out"
    priority                   = 210
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "AzureKeyVault"
  },
  {
    name                       = "Allow-ContainerRegistry-Out"
    priority                   = 220
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "AzureContainerRegistry"
  },
  {
    name                       = "Allow-LogAnalytics-Out"
    priority                   = 230
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "AzureMonitor"
  },
  {
    name                       = "Deny-Internet-Out"
    priority                   = 300
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "0.0.0.0/0"
  },

  {
    name                       = "Allow-All-Outbound-Temp"
    priority                   = 101
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "0.0.0.0/0"
  },

]

# NSG Rules - Ingress
security_rules_ingress = [
  {
    name                       = "Allow-Public-HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.2.0/24"
  },
  {
    name                       = "Allow-AppGW-to-AKS"
    priority                   = 120
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80", "443"]
    source_address_prefix      = "10.0.2.0/24"
    destination_address_prefix = "10.0.1.0/24"
  },
  {
    name                         = "Allow-AppGW-Probes"
    priority                     = 130
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_ranges      = ["65200-65535"]
    source_address_prefix        = "AzureLoadBalancer"
    destination_address_prefixes = ["10.0.2.0/24"]
  },
  {
    name                       = "Allow-AzureServices-Out"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "10.0.2.0/24"
    destination_address_prefix = "AzureCloud"
  },
  {
    name                       = "Deny-Internet-Out"
    priority                   = 300
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.2.0/24"
    destination_address_prefix = "0.0.0.0/0"
  }
]