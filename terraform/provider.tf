terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # tfstateをterraform cloudで管理
  cloud {
    organization = "ka70ka70"

    workspaces {
      name = "engineed-ec2-exam"
    }
  }
}

provider "aws" {
  # shared_credentials_file = "[$HOME/.aws/credentials]"
  profile                 = "engineed"
  region = "ap-northeast-1"
}
