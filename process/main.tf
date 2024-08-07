########################################################################
# Enable APIs
########################################################################
resource "google_project_service" "enable_project_apis" {
  count   = length(local.enable_services)
  project = var.project_id
  service = local.enable_services[count.index]
  disable_on_destroy = false
  timeouts {
    create = "30m"
    update = "40m"
  }
}

########################################################################
# Create SA to invoke Document AI
########################################################################

resource "google_service_account" "service_account" {
  project = var.project_id
  account_id   = "document-ai-service-account"
  display_name = "Service Account to use with Document AI"
}
resource "google_project_iam_binding" "project" {
  project = var.project_id
  role    = "roles/documentai.apiUser"

  members = [
    google_service_account.service_account.member
  ]
}

resource "google_project_iam_binding" "service_usage" {
  project = var.project_id
  role    = "roles/serviceusage.serviceUsageConsumer"

  members = [
    google_service_account.service_account.member
  ]
}

########################################################################
# Enable Logging
########################################################################

resource "google_project_iam_audit_config" "project" {
  count   = length(local.enable_logs)
  project = var.project_id
  service = local.enable_logs[count.index]
  audit_log_config {
    log_type = "ADMIN_READ"
  }
  audit_log_config {
    log_type = "DATA_READ"
  }
  audit_log_config {
    log_type = "DATA_WRITE"
  }
}


########################################################################
# Create Source Object and Bucket
########################################################################
resource "random_string" "bucket_suffix" {
  length = 4
  special = false
  lower = true
  upper = false
}

resource "google_storage_bucket" "source_bucket" {
  name          = "document-ai-source-${random_string.bucket_suffix.id}"
  location      = "US"
  project       = var.project_id
  force_destroy = true

  uniform_bucket_level_access = true

}

resource "google_storage_bucket_object" "samnple_object" {
  name   = "multi_document.pdf"
  source = "./multi_document.pdf"
  bucket = google_storage_bucket.source_bucket.name
}

# resource "google_storage_bucket" "destination_bucket" {
#   name          = "document-ai-destination-${random_string.bucket_suffix.id}"
#   location      = "US"
#   project       = var.project_id
#   force_destroy = true

#   uniform_bucket_level_access = true

# }

########################################################################
# Create Document AI Processor - Use Prebuilt W9 Processor
########################################################################

resource "google_document_ai_processor" "processor" {
  location      = "us"
  project       = var.project_id
  display_name  = "exfil-data"
  type          = "FORM_W9_PROCESSOR"
}

resource "google_document_ai_processor_default_version" "processor" {
  processor     = google_document_ai_processor.processor.id
  version       = "${google_document_ai_processor.processor.id}/processorVersions/stable"

  lifecycle {
    ignore_changes = [
      # Using "stable" or "rc" will return a specific version from the API; suppressing the diff.
      version,
    ]
  }
}

resource "google_project_service_identity" "dai_sa" {
  provider = google-beta

  project = var.project_id
  service = "documentai.googleapis.com"
}