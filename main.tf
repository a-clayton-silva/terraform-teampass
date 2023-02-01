terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  ## export AWS_SECRET_ACCESS_KEY=
  ## export AWS_ACCESS_KEY=
  ## AWS CONFIGURE
  ## profile = ""
}