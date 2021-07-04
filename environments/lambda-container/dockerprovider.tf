data "aws_ecr_authorization_token" "token" {
}

resource "aws_ecr_repository" "sample_dockerprovider" {
  name                 = "sample-dockerprovider"
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }
}

resource "docker_registry_image" "sample_dockerprovider" {
  name = "sample-dockerprovider:latest"
  build {
    context = "app"
  }
}
