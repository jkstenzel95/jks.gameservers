curl -LsS https://raw.githubusercontent.com/gruntwork-io/gruntwork-installer/master/bootstrap-gruntwork-installer.sh | bash /dev/stdin --version v0.0.38
gruntwork-install --binary-name "kubergrunt" --repo "https://github.com/gruntwork-io/kubergrunt" --tag "v0.5.13"
terraform init --upgrade
terraform apply