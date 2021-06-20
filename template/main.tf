variable "aws_region" {
}

# Assign the region to the provider in this case AWS
provider "aws" {
  region = "${var.aws_region}"
}

terraform {
  backend "local" {
    path = "/Users/Aditya/state/folder/terraform.tfstate"
  }
}

data "aws_caller_identity" "current" {}
