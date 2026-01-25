# Namespace - API
resource "kubernetes_namespace_v1" "api" {
  metadata {
    name = "api"
    labels = {
      "app.kubernetes.io/name"       = "stt-processing"
      "app.kubernetes.io/component"  = "api"
      "app.kubernetes.io/part-of"    = "speech-platform"
      "app.kubernetes.io/managed-by" = "engineering"
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
    SPEECH_QUEUE_NAME     = var.speech_queue_name
    SEARCH_QUEUE_NAME     = var.search_queue_name
    STORAGE_QUEUE_NAME    = var.storage_queue_name
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
