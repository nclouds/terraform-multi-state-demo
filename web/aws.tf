provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
}

data "terraform_remote_state" "network" {
    backend = "s3"
    config {
        bucket = "terraform-state-useast1"
        key = "network/terraform.tfstate"
        region = "us-east-1"
    }
}

data "terraform_remote_state" "security" {
    backend = "s3"
    config {
        bucket = "terraform-state-useast1"
        key = "security/terraform.tfstate"
        region = "us-east-1"
    }
}
