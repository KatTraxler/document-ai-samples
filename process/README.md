## Document AI Processors - Process

### Process
Terraform deployment, which creates
- One Cloud Storage Bucket
- Uploads a sample pdf to Source Bucket
- Document AI W9 form prebuilt/pretrained processor
- Workflow to process pdf from the source bucket and return the output using the `googleapis.documentai.v1.projects.locations.processors.process` method
- One Service Account assigned the `Document AI API User` Role, which the workflow operates as.


### Terraform Deployment
1. Navigate to the `process` folder.
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


#### Outputs


- Document AI Service Agent Email Address



### Workflow


The workflow created in the Terraform deployment takes the sample PDF previously uploaded into the source bucket, submits it to the previously created Document AI W9 form processor, and return the result to the workflow


### Workflow Execution


```
gcloud workflows run document-ai-batchProcess `--data={"destinationBucket":""}`
```


### Troubleshooting
It can take several minutes for a processor to be ready to receive an incoming request. As a result, workflows executed soon after the TF deployment may result in a 403. 
If this happens, retry until the batch processing is successful, typically > 1 minute.



