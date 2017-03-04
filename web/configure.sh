terraform remote config -backend=s3 -backend-config="bucket=${1:-terraform-state-demo}" -backend-config="key=web/terraform.tfstate" -backend-config="region=us-east-1"
