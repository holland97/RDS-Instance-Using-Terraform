terraform {
  required_providers {
    aws = {
      version = "~> 5.2"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}
