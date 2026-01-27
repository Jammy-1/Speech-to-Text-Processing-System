# Namespace - Speech
resource "kubernetes_namespace_v1" "speech" {
  metadata {
    name = "speech-worker"
    labels = {
      environment = var.k8_environment
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
    SPEECH_REGION            = var.location
    SERVICE_BUS_NAMESPACE    = var.service_bus_namespace
    SERVICE_BUS_QUEUE_SPEECH = var.speech_queue
    STORAGE_ACCOUNT_NAME     = var.storage_account_name
    STORAGE_CONTAINER_NAME   = var.transcripts_container_name
  }
}

# Secret - Speech
resource "kubernetes_secret_v1" "speech_secret" {
  metadata {
    name      = "speech-secrets"
    namespace = kubernetes_namespace_v1.speech.metadata[0].name
  }

  data = {
    SPEECH_KEY = var.speech_key
  }

  type = "Opaque"
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

          env_from {
            secret_ref {
              name = kubernetes_secret_v1.speech_secret.metadata[0].name
            }
          }
        }
      }
    }
  }
}
