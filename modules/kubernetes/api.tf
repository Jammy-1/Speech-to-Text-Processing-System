# Namespace - API
resource "kubernetes_namespace_v1" "api" {
  metadata {
    name = "api-stt"
    labels = {
      "app.kubernetes.io/name"       = "api-stt"
      "app.kubernetes.io/component"  = "api"
      "app.kubernetes.io/part-of"    = var.k8_label_project_name
      "app.kubernetes.io/managed-by" = "engineering"
    }
  }
}

# Service Account
resource "kubernetes_service_account_v1" "api_sa" {
  metadata {
    name      = "api-sa"
    namespace = kubernetes_namespace_v1.api.metadata[0].name

    labels = {
      "azure.workload.identity/use" = "true"
    }

    annotations = {
      "azure.workload.identity/client-id" = var.uai_api_worker_client_id
    }
  }
}

# Configuration Map - Internal API
resource "kubernetes_config_map_v1" "api_config_map" {
  metadata {
    name      = "api-config"
    namespace = kubernetes_namespace_v1.api.metadata[0].name
  }

  data = {
    SERVICE_BUS_NAMESPACE = "${var.service_bus_name}.servicebus.windows.net"
    STORAGE_QUEUE_NAME    = var.storage_queue
  }
}

# Deployment - Interal API
resource "kubernetes_deployment_v1" "api_worker" {
  metadata {
    name      = "transcriber-api"
    namespace = kubernetes_namespace_v1.api.metadata[0].name
  }

  spec {
    replicas = 2

    selector {
      match_labels = { app = "api" }
    }

    template {
      metadata {
        labels = { app = "api" }
      }

      spec {
        service_account_name = kubernetes_namespace_v1.api.metadata[0].name

        container {
          name  = "api"
          image = var.api_worker_image

          port {
            container_port = 8000
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map_v1.api_config_map.metadata[0].name
            }
          }
        }
      }
    }
  }
}

# Service - API 
resource "kubernetes_service_v1" "api_service" {
  metadata {
    name      = "api-service"
    namespace = kubernetes_namespace_v1.api.metadata[0].name
  }

  spec {
    selector = { app = "api" }

    port {
      port        = 80
      target_port = 8000
    }

    type = "ClusterIP"
  }
}
