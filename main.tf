variable "aws_region" {
#  default = "us-east-1"
}

# Assign the region to the provider in this case AWS
provider "aws" {
  region = "${var.aws_region}"
}

terraform {
  backend "local" {
    path = "/Users/Aditya/Downloads/mindtickle/state/us-east-1/terraform.tfstate"
  }
}

data "aws_caller_identity" "current" {}
