# General
state_resource_group_name = "Speech-to-Text-Processing-System-Staging-Backend"
location                  = "uksouth"

# Storage                       
state_storage_account_name   = "stagingbackendstt"
state_storage_container_name = "stage-state-container-bakend"
state_key_backend            = "backend/terraform.tfstate"
state_key_deployment         = "staging/terraform.tfstate"

# Environment Tags
tags = {
  environment = "Staging-backend"
  project     = "Staging-Speech-to-Text-Processing-System"
  owner       = "development-team"
  cost_center = "Staging-Speech-to-Text-Processing-System"
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