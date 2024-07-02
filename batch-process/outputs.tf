########################################################################
# Define outputs
########################################################################
output "document_ai_service_agent" {
  value = google_project_service_identity.dai_sa.email
}


output "document_ai_destination_bucket" {
  value = google_storage_bucket.destination_bucket.url
}