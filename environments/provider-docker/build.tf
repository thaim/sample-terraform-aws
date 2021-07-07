locals {
  ecr_address = format("%v.dkr.ecr.%v.amazonaws.com", data.aws_caller_identity.this.account_id, data.aws_region.current.name)
}

resource "docker_registry_image" "this" {
  name = "${local.ecr_address}/${aws_ecr_repository.this.name}:latest"

  build {
    context = "context"
  }
}

resource "docker_image" "this" {
  name = "${local.ecr_address}/${aws_ecr_repository.this.name}:latest"

  build {
    path    = "context"
  }
}

resource "aws_ecr_repository" "this" {
  name = "sample"
}
