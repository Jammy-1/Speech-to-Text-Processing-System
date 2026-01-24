# AKS
output "aks_cluster_name" { value = azurerm_kubernetes_cluster.main.name }
output "aks_principal_id" { value = azurerm_kubernetes_cluster.main.identity[0].principal_id }

# Outputs For K8's Provider
output "kube_host" { value = azurerm_kubernetes_cluster.main.kube_admin_config[0].host }

output "kube_client_certificate" { 
    value = azurerm_kubernetes_cluster.main.kube_admin_config[0].client_certificate
    sensitive = true
}

output "kube_client_key" {
  value     = azurerm_kubernetes_cluster.main.kube_admin_config[0].client_key
  sensitive = true
}

output "kube_cluster_ca_certificate" {
  value     = azurerm_kubernetes_cluster.main.kube_admin_config[0].cluster_ca_certificate
  sensitive = true
}