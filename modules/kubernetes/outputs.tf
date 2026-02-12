# API
output "k8_api_sa_name" { value = kubernetes_service_account_v1.api_sa.metadata[0].name }

# Speech
output "k8_speech_sa_name" { value = kubernetes_service_account_v1.speech_worker_sa.metadata[0].name }

# Search
output "k8_search_sa_name" { value = kubernetes_service_account_v1.search_worker_sa.metadata[0].name }