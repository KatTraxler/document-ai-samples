resource "google_workflows_workflow" "workflow_to_process_data_on_documentai" {
  name            = "document-ai-process-data"
  description     = "A workflow that uses the process method on a Document AI processor to extract text from a pdf stored in a GCS bucket and return the result"
  service_account = google_service_account.service_account.id
  project         = var.project_id
  region          = var.region  
  source_contents = <<-EOF


######################################################################################
## Description
######################################################################################
#  This workflow takes the sample pdf previously uploaded into the source bucket, submits
#  to a previously created Document AI W9 form processor and returns the output.



######################################################################################
## Main Workflow Execution
######################################################################################
main:
  steps:
    - vars:
        assign:
          - input_gcs_bucket: ${google_storage_bucket.source_bucket.url}
          - processor_id: ${google_document_ai_processor.processor.id}
    - process:
        call: googleapis.documentai.v1.projects.locations.processors.process
        args:
          name: $${processor_id}
          location: "us"
          body:
            gcsDocument:
              gcsUri: ${google_storage_bucket.source_bucket.url}/${google_storage_bucket_object.samnple_object.name}
              mimeType: "application/pdf"
        result: process_resp
    - return:
        return: $${process_resp}

  EOF

}