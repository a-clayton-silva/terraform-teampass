terraform {
  backend "s3" {
    bucket = "tf-state-terraform-projeto1"
    key    = "terraform/state"
    region = "us-east-1"
  }
}