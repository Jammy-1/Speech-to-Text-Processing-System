# General
state_resource_group_name = "Speech-to-Text-Processing-System-Production-Backend"
location                  = "uksouth"

# Storage                       
state_storage_account_name   = "prodbackendstt"
state_storage_container_name = "prod-state-container-bakend"
state_key_backend            = "backend/terraform.tfstate"
state_key_deployment         = "production/terraform.tfstate"

# Environment Tags
tags = {
  environment = "production-backend"
  project     = "production-Speech-to-Text-Processing-System"
  owner       = "development-team"
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