# General
resource_group_name = "Speech-to-Text-Processing-System-Development"
location            = "uksouth"

# Storage                 
storage_account_name   = "sttprocessingdev"
storage_container_name = "statecontainerdev"
state_key_backend      = "backend/terraform.tfstate"
state_key_deployment   = "development/terraform.tfstate"

# Event Hub 
eventhub_namespace      = "speech-to-text-processing-system-development"
eventhub_name           = "speech-to-text-processing-system-development"
eventhub_auth_rule_name = "event-auth-rule-development"

# Environment Tags
env_tags = {
  environment = "development-backend"
  project     = "development-Speech-to-Text-Processing-System"
  owner       = "development-backend-team"
  cost_center = "development-Speech-to-Text-Processing-System"
}

# Backend Tags
backend_tags = {
  project_backend       = "dev-speech-to-text-processing-system-backend"
  managed_by            = "terraform"
  purpose               = "terraform-state"
  cost_center_secondary = "dev-speech-to-text-processing-system-backend"
  lifecycle             = "long-lived"
  criticality           = "high"
  backup_required       = "true"
}