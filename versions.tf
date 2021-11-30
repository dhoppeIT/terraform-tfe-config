terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = ">= 0.26.1, < 1.0.0"
    }
  }

  required_version = ">= 1.0"
}
