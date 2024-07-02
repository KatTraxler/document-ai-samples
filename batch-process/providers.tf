#################################################################################
# Define required providers
#################################################################################
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.62.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.27.0"
    }
  }
}


########################################################################
# Define providers
########################################################################
data "google_client_config" "default" {}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
  user_project_override = true
  billing_project = var.project_id
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
  user_project_override = true
  billing_project = var.project_id
}