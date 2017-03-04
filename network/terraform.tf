terraform {
  backend "s3" {
    bucket = "terraform-state-useast1"
    key    = "network/terraform.state"
    region = "us-east-1"
  }
}
