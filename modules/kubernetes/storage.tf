# Namespace - Storage 
resource "kubernetes_namespace_v1" "storage" {
  metadata {
    name = "storage-worker"
    labels = {
      environment = "prod"
      team        = "storage-processing"
    }
  }
}

# Configuration Map - Storage
resource "kubernetes_config_map_v1" "storage_config_map" {
  metadata {
    name      = "storage-config"
    namespace = kubernetes_namespace_v1.storage.metadata[0].name
  }

  data = {
    STORAGE_ACCOUNT_NAME   = var.storage_account_name
    STORAGE_CONTAINER_NAME = var.transcripts_container_name
    SERVICE_BUS_QUEUE      = var.storage_queue_name
  }
}

# Deployment - Storage
resource "kubernetes_deployment_v1" "storage_worker" {
  metadata {
    name      = "storage-worker"
    namespace = kubernetes_namespace_v1.storage.metadata[0].name
  }

  spec {
    replicas = 2

    selector {
      match_labels = { app = "storage-worker" }
    }

    template {
      metadata {
        labels = { app = "storage-worker" }
      }

      spec {
        container {
          name  = "storage-worker"
          image = var.storage_worker_image

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
              name = kubernetes_config_map_v1.storage_config_map.metadata[0].name
            }
          }
        }
      }
    }
  }
}