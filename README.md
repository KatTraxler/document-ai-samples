# Document AI Processors

## Modules 

### Batch Processing 
These two workflows retrieve a PDF from a source GCS bucket and, using one of the Batch Processing, transform and return the output to a user-defined GCS bucket.
Retrieval of the GCS object and writing the processor result is executed as the Document AI Core Service Agent (`Document AI Core Service Agent Role`).

- [Batch Process Processors](./batch-process/README.md)
- [Batch Process Processor Versions](./batch-processVersions/README.md)

### Standard / Online Processing
These two workflows retrieve a PDF from a source GCS bucket, transform it using one of the standard process methods, and return the output as the result of the workflow.
Retrieval of a GCS object as input is executed as the initial caller to Document AI, in this case, a user-managed service account.

- [Online Process](./process/README.md)
- [Online Process -  Versions](./processVersions/README.md)


## Terraform Deployment
1. Navigate to the desired module folder.
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



## Permissions

### Batch Processing

In order to execute batch processing, an end user needs only the `Document AI API User` role granting them either the `documentai.processors.processBatch` or the `documentai.processorVersions.processBatch` permissions.

### Standard / Online Processing

In order to execute a standard or online process, an end user needs BOTH:
-  The `Document AI API User` role, granting them either the `documentai.processors.process` or the `documentai.processorVersions.process` permissions.
-  The `storage.objects.get` permission if input data is stored in GCS.


## Troubleshooting
It can take several minutes for a processor to be ready to receive an incoming request. As a result, workflows executed soon after the TF deployment may result in a 403. 
If this happens, retry until the batch processing is successful, typically > 1 minute.

