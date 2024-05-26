provider "aws" {
  region = "ap-northeast-1"
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

resource "aws_lambda_function" "this" {
  provider = aws.virginia

  function_name = "sample"
  filename      = data.archive_file.this.output_path
  role          = aws_iam_role.this.arn
  handler       = "lambda.handler"
  runtime       = "nodejs20.x"
}

data "archive_file" "this" {
  type        = "zip"
  output_path = "${path.module}/lambda.zip"
  source {
    content  = "dummy"
    filename = "lambda.js"
  }
}

resource "aws_iam_role" "this" {
  name               = "sample"
  assume_role_policy = data.aws_iam_policy_document.assume_lambda.json
}

data "aws_iam_policy_document" "assume_lambda" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
