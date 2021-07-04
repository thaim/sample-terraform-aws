resource "aws_lambda_function" "sample_dockerprovider" {
  function_name = "sample-container-dockerprovider"
  role          = aws_iam_role.lambda.arn

  package_type = "Image"
  image_uri    = "${aws_ecr_repository.sample_dockerprovider.repository_url}:latest"

  environment {
    variables = {
      MESSAGE = "sample-container-dockerprovider"
    }
  }
}

resource "aws_cloudwatch_log_group" "dockerprovider" {
  name = "/aws/lambda/${aws_lambda_function.sample_dockerprovider.function_name}"
}

resource "aws_ecr_repository" "sample_dockerprovider" {
  name                 = "sample-dockerprovider"
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }
}

data "aws_ecr_authorization_token" "token" {
}

# Dockerレジストリにダミーイミエージを格納しておく
resource "docker_registry_image" "sample_dockerprovider" {
  name = "${aws_ecr_repository.sample_dockerprovider.repository_url}:latest"

  build {
    context = "dummy"
  }
}
