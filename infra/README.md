# Infra
The Terraform and script repository for infrastructure deployment and initialization

## Directories
### /bootstrap
- Deploys build pipelines for main infra
- Infra that's only meant to be deployed once (infra storage, build pipelines)
### /service
- The main infra for game servers and the surrounding services

Create keypair jks-gameservers
Create SSH security group for ssh, put id in config