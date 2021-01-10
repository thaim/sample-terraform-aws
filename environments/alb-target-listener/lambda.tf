resource "aws_lambda_function" "sample" {
  function_name = "sample-lambda-alb"
  handler = "index.handler"
  runtime = "nodejs12.x"

  filename = data.archive_file.lambda_function.output_path
  source_code_hash = data.archive_file.lambda_function.output_base64sha256

  role = aws_iam_role.iam_for_lambda.arn
}

data "archive_file" "lambda_function" {
  type = "zip"
  source_dir = "lambda"
  output_path = "lambda.zip"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "AWSLambdaBasicRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role = aws_iam_role.iam_for_lambda.name
  policy_arn = data.aws_iam_policy.lambda_basic_execution.arn
}

data "aws_iam_policy" "lambda_basic_execution" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_permission" "with_lb" {
  statement_id = "ALBAllowInvokeLambda"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sample.arn
  principal = "elasticloadbalancing.amazonaws.com"
  source_arn = aws_lb_target_group.sample_alb_tg_lambda.arn
}
