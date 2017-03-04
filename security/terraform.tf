terraform {
  backend "s3" {
    bucket = "terraform-state-useast1"
    key    = "security/terraform.state"
    region = "us-east-1"
  }
}
