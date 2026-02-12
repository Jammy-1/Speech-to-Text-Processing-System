# Namespace - Search 
resource "kubernetes_namespace_v1" "search" {
  metadata {
    name = "search-stt"
    labels = {
      "app.kubernetes.io/name"        = "search-stt"
      "app.kubernetes.io/environment" = var.k8_environment
      "app.kubernetes.io/component"   = "stt-search"
      "app.kubernetes.io/part-of"     = var.k8_label_project_name
      "app.kubernetes.io/managed-by"  = "engineering"
    }
  }
}

# Configuration Map - Search
resource "kubernetes_config_map_v1" "search_config_map" {
  metadata {
    name      = "search-config"
    namespace = kubernetes_namespace_v1.search.metadata[0].name
  }

  data = {
    SEARCH_ENDPOINT          = "https://${var.search_service_name}.search.windows.net"
    SEARCH_REGION            = var.location
    SEARCH_INDEX_NAME        = var.search_index_name
    SERVICE_BUS_NAMESPACE    = var.service_bus_namespace
    SERVICE_BUS_QUEUE_SEARCH = var.search_queue
    STORAGE_ACCOUNT_NAME     = var.storage_account_name
    STORAGE_CONTAINER_NAME   = var.transcripts_container_name
  }
}

# Service Account
resource "kubernetes_service_account_v1" "search_worker_sa" {
  metadata {
    name      = "search-worker-sa"
    namespace = kubernetes_namespace_v1.search.metadata[0].name

    labels = {
      "azure.workload.identity/use" = "true"
    }

    annotations = {
      "azure.workload.identity/client-id" = var.uai_search_worker_name
    }
  }
}

# Deployment - Search 
resource "kubernetes_deployment_v1" "search_worker" {
  metadata {
    name      = "search-worker"
    namespace = kubernetes_namespace_v1.search.metadata[0].name
  }

  spec {
    replicas = 2

    selector {
      match_labels = { app = "search-worker" }
    }

    template {
      metadata {
        labels = { app = "search-worker" }
      }

      spec {
        container {
          name              = "search-worker"
          image             = var.search_worker_image
          image_pull_policy = "Always"

          resources {
            requests = {
              cpu    = "500m"
              memory = "1Gi"
            }
            limits = {
              cpu    = "1"
              memory = "2Gi"
            }
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map_v1.search_config_map.metadata[0].name
            }
          }
        }
      }
    }
  }
}

