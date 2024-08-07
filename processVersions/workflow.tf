resource "google_workflows_workflow" "workflow_to_processVersions_data_on_documentai" {
  name            = "document-ai-processVersions-data"
  description     = "A workflow that uses the process method on a Processor Version from the Document AI service to extract text from a pdf stored in a GCS bucket and return the result"
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
          - processor_id_version: $${processor_id +"/processorVersions/stable"}
    - processVersions:
        call: googleapis.documentai.v1.projects.locations.processors.processorVersions.process
        args:
          name: $${processor_id_version}
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