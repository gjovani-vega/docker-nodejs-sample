terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.55.0"
    }
  }
}

provider "aws" {
  region  = "eu-central-1"
  profile = "vega_internal_devops_kurs"
}
