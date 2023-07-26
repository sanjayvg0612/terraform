terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
  access_key = "AKIA25GGKGSZNMVZYVVC"
  secret_key = "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"
}
