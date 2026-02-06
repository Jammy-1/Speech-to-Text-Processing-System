# General
resource_group_name = "Speech-to-Text-Processing-System-Staging"
location            = "uksouth"

# Storage                 
storage_account_name   = "sttprocessingstage"
storage_container_name = "statecontainerstage"
state_key_backend      = "backend/terraform.tfstate"
state_key_deployment   = "development/terraform.tfstate"

# Event Hub 
eventhub_namespace      = "speech-to-text-processing-system-staging"
eventhub_name           = "speech-to-text-processing-system-staging"
eventhub_auth_rule_name = "event-auth-rule-staging"

# Environment Tags
env_tags = {
  environment = "staging-backend"
  project     = "staging-Speech-to-Text-Processing-System"
  owner       = "staging-backend-team"
  cost_center = "staging-Speech-to-Text-Processing-System"
}

# Backend Tags
backend_tags = {
  project_backend       = "staging-speech-to-text-processing-system-backend"
  managed_by            = "terraform"
  purpose               = "terraform-state"
  cost_center_secondary = "staging-speech-to-text-processing-system-backend"
  lifecycle             = "long-lived"
  criticality           = "high"
  backup_required       = "true"
}