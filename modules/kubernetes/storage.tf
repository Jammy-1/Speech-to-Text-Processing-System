# Namespace - Storage 
resource "kubernetes_namespace_v1" "storage" {
  metadata {
    name = "storage-stt"
    labels = {
      "app.kubernetes.io/name"        = "storage-stt"
      "app.kubernetes.io/environment" = var.k8_environment
      "app.kubernetes.io/component"   = "speech"
      "app.kubernetes.io/part-of"     = var.k8_label_project_name
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

# Service Account - Storage SA
resource "kubernetes_service_account_v1" "storage_worker_sa" {
  metadata {
    name      = "storage-worker-sa"
    namespace = kubernetes_namespace_v1.storage.metadata[0].name

    labels = {
      "azure.workload.identity/use" = "true"
    }

    annotations = {
      "azure.workload.identity/client-id" = var.uai_storage_worker_name
    }
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
          name              = "storage-worker"
          image             = var.storage_worker_image
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
              name = kubernetes_config_map_v1.storage_config_map.metadata[0].name
            }
          }
        }
      }
    }
  }
}