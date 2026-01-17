# AKS
output "aks_cluster_name" { value = azurerm_kubernetes_cluster.main.name }
output "aks_principal_id" { value = azurerm_kubernetes_cluster.main.identity[0].principal_id }