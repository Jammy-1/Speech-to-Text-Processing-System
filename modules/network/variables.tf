# General 
variable "resource_group_name" {}
variable "location" {}
variable "tags" { type = map(string) }

# Vnet
variable "vnet_name" {}
variable "storage_dns_link_name" { type = string }

# Subnet
variable "subnet_name_aks" { type = string }
variable "subnet_name_ingress" { type = string }

# Application Gateway
variable "app_gw_name" { type = string }
variable "app_gw_ip_config_name" { type = string }
variable "app_gw_frontend_ip_config_name" { type = string }
variable "app_gw_aks_backend_pool_ip_name" { type = string }

# Private Endpoint
variable "private_endpoint_name_storage_pe" { type = string }
variable "storage_account_id" { type = string }

# Public Ip
variable "public_ip_frontend_name" { type = string }
variable "public_ip_app_gw_name" { type = string }

# NSG
variable "nsg_name_aks" { type = string }
variable "nsg_name_ingress" { type = string }

# NSG Rules - AKS
variable "security_rules_aks" {
  type = list(object({
    name                                       = string
    priority                                   = number
    direction                                  = string
    access                                     = string
    protocol                                   = string
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
    source_address_prefix                      = optional(string) 
    source_address_prefixes                    = optional(list(string))
    source_application_security_group_ids      = optional(list(string))
    destination_address_prefix                 = optional(string) 
    destination_address_prefixes               = optional(list(string))
    destination_application_security_group_ids = optional(list(string))
  }))
}