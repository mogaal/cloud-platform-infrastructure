terraform {
  required_providers {
    auth0 = {
      source  = "auth0/auth0"
      version = "0.35.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "4.26.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }
  required_version = ">= 0.14"
}
