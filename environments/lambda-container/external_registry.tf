# 外部のダミーECRレジストリおよびコンテナイメージを準備しておく

resource "aws_lambda_function" "sample_prepared" {
  function_name = "sample-container-prepared"
  role          = aws_iam_role.lambda.arn

  package_type = "Image"
  # 初期構築時はダミーイメージを指定しておく
  image_uri    = "${data.aws_ecr_repository.prepared.repository_url}:latest"

  lifecycle {
    ignore_changes = [image_uri]
  }

  environment {
    variables = {
      MESSAGE = "sample-container-prepared"
    }
  }
}

# 実際にlambda関数で実行するコンテナイメージを格納するレジストリ
resource "aws_ecr_repository" "sample_prepared" {
  name                 = "sample-prepared"
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }
}

# 以下は事前に手動で構築しておいたECRレジストリおよびコンテナイメージ
data "aws_ecr_repository" "prepared" {
  name                 = "prepared"
}
