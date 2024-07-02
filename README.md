## Document AI W9 Processor
Terraform deployment which creates
- Two Cloud Storage Buckets (Source and Destination)
- Uploads a sample pdf to Source Bucket
- Document AI W9 form processor
- Workflow to process pdf from source bucket to a destination
- One Service Account assigned the Document AI admin role which the workflow operates as

## Terraform Deployment
1. Navigate to the `batch-process` folder.
2. Complate a `terraform.tfvars` file used the `TEMPLATE.tfvars` file 

        ```
        terraform init 
        ```    
        ```
        terraform plan 
        ```   
        ```
        terraform apply
        ```   

### Outputs

- Document AI Service Agent Email Address: Assign Storage permissions to this Sa if outputting processor results to a bucket outside of the project
- Destination Bucket URL: A destination bucket created in the projectg to output results to.


## Workflow 

The workflow created in the terraform deployment takes the sample pdf previously uploaded into the source bucket, submits to the previously created Document AI W9 form processor and outputs the results to a destination bucket of your chosing.
A destination bucket is created in your GCP project during the TF deployment however a custom bucket can be specified outside the project.
If a bucket is specified outside the deployment project, `storage.object.create` permission needs to be granted to the Document AI Service Agent.

## Workflow Execution
Specify your destination bucket in the data field below.

```
gcloud workflows run document-ai-batchProcess-data `--data={"destinationBucket":""}` 
```
