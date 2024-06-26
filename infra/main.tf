terraform {
  required_version = ">= 1.7.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.55.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-state-gjovani"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    profile        = "vega_internal_devops_kurs"
    dynamodb_table = "terraform-state-lock-gjovani"
  }
}

provider "aws" {
  region  = "eu-central-1"
  profile = "vega_internal_devops_kurs"
}
