########################################################################
# Define outputs
########################################################################
output "document_ai_service_agent" {
  value = google_project_service_identity.dai_sa.email
}

