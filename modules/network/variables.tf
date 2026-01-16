# General 
variable "resource_group_name" {}
variable "location" {}

# Vnet
variable "vnet_name" {}

# Subnet
variable "subnet_name_aks" { type = string }
variable "subnet_name_ingress" { type = string }

# Private Endpoint
variable "private_endpoint_name_storage_pe" { type = string }
variable "storage_account_id" { type = string }

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
    source_address_prefix                      = optional(string) # One of these is required
    source_address_prefixes                    = optional(list(string))
    source_application_security_group_ids      = optional(list(string))
    destination_address_prefix                 = optional(string) # One of these is required
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
    source_address_prefix                      = optional(string) # One of these is required
    source_address_prefixes                    = optional(list(string))
    source_application_security_group_ids      = optional(list(string))
    destination_address_prefix                 = optional(string) # One of these is required
    destination_address_prefixes               = optional(list(string))
    destination_application_security_group_ids = optional(list(string))
  }))
}