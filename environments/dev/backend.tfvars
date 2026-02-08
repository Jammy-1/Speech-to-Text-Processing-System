# General
state_resource_group_name = "Speech-to-Text-Processing-System-Development-Backend"
location                  = "uksouth"

# Storage                       
state_storage_account_name   = "devbackendstt"
state_storage_container_name = "dev-state-container-bakend"
state_key_backend            = "backend/terraform.tfstate"
state_key_deployment         = "development/terraform.tfstate"

# Environment Tags
tags = {
  environment = "development-backend"
  project     = "development-Speech-to-Text-Processing-System"
  owner       = "development-team"
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