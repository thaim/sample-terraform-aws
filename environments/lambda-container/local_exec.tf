# local-execでECRレジストリ構築と同時にダミーイメージをpushしておく

resource "aws_lambda_function" "sample_localexec" {
  function_name = "sample-container-localexec"
  role          = aws_iam_role.lambda.arn

  package_type = "Image"
  image_uri    = "${aws_ecr_repository.sample_localexec.repository_url}:latest"

  lifecycle {
    ignore_changes = [image_uri]
  }

  environment {
    variables = {
      MESSAGE = "sample-container-localexec"
    }
  }

  depends_on = [null_resource.generate_dummy_image]
}

resource "aws_cloudwatch_log_group" "localexec" {
  name = "/aws/lambda/${aws_lambda_function.sample_localexec.function_name}"
}

# 実際にlambda関数で実行するコンテナイメージを格納するレジストリ
resource "aws_ecr_repository" "sample_localexec" {
  name                 = "sample-localexec"
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }
}

# ダミーコンテナイメージの保存
resource "null_resource" "generate_dummy_image" {
  provisioner "local-exec" {
    command = "aws ecr get-login-password | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com"
  }

  # ダミーイメージとしてalpineを利用する
  provisioner "local-exec" {
    command = "docker pull alpine:latest"
  }

  provisioner "local-exec" {
    command = "docker tag alpine:latest ${aws_ecr_repository.sample_localexec.repository_url}"
  }

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.sample_localexec.repository_url}"
  }
}
