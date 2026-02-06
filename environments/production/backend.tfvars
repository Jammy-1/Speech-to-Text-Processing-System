# General
resource_group_name = "Speech-to-Text-Processing-System-Production"
location            = "uksouth"

# Storage                 
storage_account_name   = "sttprocessingprod"
storage_container_name = "statecontainerprod"
state_key_backend      = "backend/terraform.tfstate"
state_key_deployment   = "production/terraform.tfstate"

# Event Hub 
eventhub_namespace      = "speech-to-text-processing-system-production"
eventhub_name           = "speech-to-text-processing-system-production"
eventhub_auth_rule_name = "event-auth-rule-production"

# Environment Tags
env_tags = {
  environment = "production-backend"
  project     = "production-Speech-to-Text-Processing-System"
  owner       = "production-backend-team"
  cost_center = "production-Speech-to-Text-Processing-System"
}

# Backend Tags
backend_tags = {
  project_backend       = "prod-speech-to-text-processing-system-backend"
  managed_by            = "terraform"
  purpose               = "terraform-state"
  cost_center_secondary = "prod-speech-to-text-processing-system-backend"
  lifecycle             = "long-lived"
  criticality           = "high"
  backup_required       = "true"
}