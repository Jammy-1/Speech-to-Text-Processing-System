# Namespace - Search 
resource "kubernetes_namespace_v1" "search" {
  metadata {
    name = "search-worker"
    labels = {
      environment = "prod"
      team        = "search-processing"
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
    SEARCH_ENDPOINT   = "https://${var.search_service_name}.search.windows.net"
    SEARCH_INDEX_NAME = var.search_index_name
    SERVICE_BUS_QUEUE = var.search_queue_name
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
          name  = "search-worker"
          image = var.search_worker_image

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
