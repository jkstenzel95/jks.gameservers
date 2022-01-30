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

## Tips
- The config here can be changed with the packages version (the generated zip file in the shared packages bucket, everything after the "shared-package_" part and before the ".zip")
    - Those changes will require any instances to be terminated to apply, as well as an instance restart to download the scripts via launch script