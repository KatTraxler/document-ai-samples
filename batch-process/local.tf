locals {
  enable_services = [
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "logging.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "storage.googleapis.com",
    "serviceusage.googleapis.com",
    "storage-component.googleapis.com",
    "documentai.googleapis.com",
    "storage-api.googleapis.com",
    "storage-component.googleapis.com",
    "workflows.googleapis.com",
    "workflowexecutions.googleapis.com"
  ]
}