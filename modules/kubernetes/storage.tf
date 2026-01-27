# Namespace - Storage 
resource "kubernetes_namespace_v1" "storage" {
  metadata {
    name = "storage-worker"
    labels = {
      "app.kubernetes.io/name"        = "storage-worker"
      "app.kubernetes.io/environment" = var.k8_environment
      "app.kubernetes.io/component"   = "speech"
      "app.kubernetes.io/part-of"     = "speech-platform"
      "app.kubernetes.io/managed-by"  = "engineering"
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
    STORAGE_ACCOUNT_NAME      = var.storage_account_name
    STORAGE_CONTAINER_NAME    = var.transcripts_container_name
    STORAGE_REGION            = var.location
    SERVICE_BUS_NAMESPACE     = var.service_bus_namespace
    SERVICE_BUS_QUEUE_STORAGE = var.storage_queue
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