resource "google_workflows_workflow" "workflow_to_batchProcessVersions_data_on_documentai" {
  name            = "document-ai-batchProcessVersions-data"
  description     = "A workflow that uses the batch processing method on a Processor Version from the Document AI service to extract text from a pdf stored in a GCS bucket and output the result to a second"
  service_account = google_service_account.service_account.id
  project         = var.project_id
  region          = var.region  
  source_contents = <<-EOF


######################################################################################
## Inputs
######################################################################################

#  {"destinationBucket":"${google_storage_bucket.destination_bucket.url}"}

######################################################################################
## Description
######################################################################################
#  This workflow takes the sample pdf previously uploaded into the source bucket, submits
#  to a previously created Document AI W9 form processor and outputs the results to a 
#  destination bucket of your chosing.
#  A destination bucket is created in this project during the deployment however a custom
#  bucket can be specified outside the project.
#  If a bucket is specified outside the deployment project, `storage.object.create` permission 
#  needs to be granted to the Document AI Service Agent.


######################################################################################
## Main Workflow Execution
######################################################################################
main:
  params: [input]
  steps:
    - vars:
        assign:
          - input_gcs_bucket: ${google_storage_bucket.source_bucket.url}
          - output_gcs_bucket: $${input.destinationBucket}
          - processor_id: ${google_document_ai_processor.processor.id}
          - processor_id_version: $${processor_id +"/processorVersions/stable"}
    - batch_processVersions:
        call: googleapis.documentai.v1.projects.locations.processors.processorVersions.batchProcess
        args:
          name: $${processor_id_version}
          location: "us"
          body:
            inputDocuments:
              gcsDocuments:
                documents:
                  - gcsUri: ${google_storage_bucket.source_bucket.url}/${google_storage_bucket_object.samnple_object.name}
                    mimeType: "application/pdf"
            documentOutputConfig:
              gcsOutputConfig:
                gcsUri: $${input.destinationBucket}
        result: batch_process_resp
    - return:
        return: $${batch_process_resp}

  EOF

}