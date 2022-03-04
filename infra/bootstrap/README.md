# Bootstrap
- The one-time resources to be deployed from local machine or wherever.
- **Begin deployment for bootstrap resources in this directory!**

## cicd
- The infra for deployment pipelines.

## jks-cluster
- The infra for deploying the EKS cluster for all servers.
- ConfigMap may fail to deploy. To rectify this, `terraform state rm module.jks_cluster.aws_iam_openid_connect_provider.oidc_provider` (or whatever configmap resource the error calls out).
- May throw the node into an unhealthy state. If so, redeploy infra through the CodePipeline for infra.

# Setup

- Set up gruntwork (used to install)
```console
curl -LsS https://raw.githubusercontent.com/gruntwork-io/gruntwork-installer/master/bootstrap-gruntwork-installer.sh | bash /dev/stdin --version v0.0.22
```
- Install kubergrunt (used in setting up OIDC for secrets access)
```console
GITHUB_OAUTH_TOKEN=<your_github_oauth_token>
gruntwork-install --binary-name "kubergrunt" --repo "https://github.com/gruntwork-io/kubergrunt" --tag "v0.5.13"
```

# Running
```console
./bootstrap.sh
```