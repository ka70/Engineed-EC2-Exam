terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  # shared_credentials_file = "[$HOME/.aws/credentials]"
  # profile                 = "engineed"
  region = "ap-northeast-1"
}
