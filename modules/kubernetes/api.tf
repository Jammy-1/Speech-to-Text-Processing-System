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

# UAI - CA -  Speech Service
resource "azurerm_user_assigned_identity" "api_uai" {
  name                = var.uai_name_api
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# RBAC 
resource "azurerm_role_assignment" "api_sb_sender_rbac" {
  scope                = var.speech_queue_id
  role_definition_name = "Azure Service Bus Data Sender"
  principal_id         = azurerm_user_assigned_identity.api_uai.principal_id
}

# Service Account
resource "kubernetes_service_account_v1" "api_sa" {
  metadata {
    name      = "api-sa"
    namespace = kubernetes_namespace_v1.api.metadata[0].name
    annotations = {
      "azure.workload.identity/client-id" = azurerm_user_assigned_identity.api_uai.client_id
    }
  }
}

# FIC - API
resource "azurerm_federated_identity_credential" "api_fic" {
  name                = "api-fic"
  resource_group_name = var.resource_group_name
  parent_id           = azurerm_user_assigned_identity.api_uai.id
  issuer              = var.aks_oidc
  subject             = "system:serviceaccount:api:api-sa"
  audience            = ["api://AzureADTokenExchange"]
}

# Configuration Map - Internal API
resource "kubernetes_config_map_v1" "api_config_map" {
  metadata {
    name      = "api-config"
    namespace = kubernetes_namespace_v1.api.metadata[0].name
  }

  data = {
    SERVICE_BUS_NAMESPACE = "${var.service_bus_name}.servicebus.windows.net"
    SPEECH_QUEUE_NAME     = var.speech_queue
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
