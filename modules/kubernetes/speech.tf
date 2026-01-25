# Namespace - Speech
resource "kubernetes_namespace_v1" "speech" {
  metadata {
    name = "speech-worker"
    labels = {
      environment = "prod"
      team        = "speech-processing"
    }
  }
}

# Configuration Map - Speech
resource "kubernetes_config_map_v1" "speech_config_map" {
  metadata {
    name      = "speech-config"
    namespace = kubernetes_namespace_v1.speech.metadata[0].name
  }

  data = {
    SPEECH_ENDPOINT          = "https://${var.cognitive_account_name}.cognitiveservices.azure.com/"
    SERVICE_BUS_QUEUE_SPEECH = var.speech_queue_name
  }
}

# Deployment - Speech 
resource "kubernetes_deployment_v1" "speech_worker" {
  metadata {
    name      = "speech-worker"
    namespace = kubernetes_namespace_v1.speech.metadata[0].name
  }

  spec {
    replicas = 3

    selector {
      match_labels = { app = "speech-worker" }
    }

    template {
      metadata {
        labels = { app = "speech-worker" }
      }

      spec {
        container {
          name  = "speech-worker"
          image = var.speech_worker_image

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
              name = kubernetes_config_map_v1.speech_config_map.metadata[0].name
            }
          }
        }
      }
    }
  }
}