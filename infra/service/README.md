# service
- The infra state for deployment by the infra CodePipeline

# usage
- Although the infrastructure here was intended to be deployed via the CI pipeline, you can do so or locally init with the following commands:
```console
terraform init -backend-config="config/{env}.s3.tfbackend"
terraform plan -var-file="./config/{env}.tfvars"
```