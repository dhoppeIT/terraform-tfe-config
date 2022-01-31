terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.68"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.26"
    }
  }

  required_version = ">= 1.0"
}
