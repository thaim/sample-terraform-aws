terraform {
  required_version = ">= 0.13"

  required_providers {
    aws = ">= 3.35"
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 2.8.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

provider "docker" {
  registry_auth {
    address  = local.ecr_address
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}
