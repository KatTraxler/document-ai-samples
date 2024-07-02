variable "project_id" {
  description = "The ID of the project to deploy resources into"
  type        = string
}

variable "region" {
  description = "The geographical region to deploy resources into"
  type        = string
}


variable "zone" {
  description = "A zone is a deployment area within a region. The fully-qualified name for a zone is made up of <region>-<zone>. For example, the fully qualified name for zone a in region us-central1 is us-central1-a."
  type        = string
}
