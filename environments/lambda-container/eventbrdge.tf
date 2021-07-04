# CloudWatch Eventsから定期的にLambda関数を呼び出す．
# Lambda関数は関数ごとに異なるメッセージをログ出力する．

resource "aws_cloudwatch_event_rule" "every_minute" {
  name                = "every-minute"
  description         = "invoke event every minute"
  schedule_expression = "cron(* * * * ? *)"
}

# prepared用
resource "aws_cloudwatch_event_target" "invoke_lambda_prepared_every_minute" {
  target_id = "InvokeLambdaPreparedEveryMinute"
  arn       = aws_lambda_function.sample_prepared.arn
  rule      = aws_cloudwatch_event_rule.every_minute.name
}

resource "aws_lambda_permission" "allow_cloudwatch_invoke_lambda_prepared" {
  statement_id  = "AllowExecuteLambdaPreparedEveryMinute"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sample_prepared.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_minute.arn
}


# local-exec用
resource "aws_cloudwatch_event_target" "invoke_lambda_localexec_every_minute" {
  target_id = "InvokeLambdaLocaLexecEveryMinute"
  arn       = aws_lambda_function.sample_localexec.arn
  rule      = aws_cloudwatch_event_rule.every_minute.name
}

resource "aws_lambda_permission" "allow_cloudwatch_invoke_lambda_localexec" {
  statement_id  = "AllowExecuteLambdaLocalexecEveryMinute"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sample_localexec.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_minute.arn
}


# docker-provider用
resource "aws_cloudwatch_event_target" "invoke_lambda_dockerprovider_every_minute" {
  target_id = "InvokeLambdaDockerProviderEveryMinute"
  arn       = aws_lambda_function.sample_dockerprovider.arn
  rule      = aws_cloudwatch_event_rule.every_minute.name
}

resource "aws_lambda_permission" "allow_cloudwatch_invoke_lambda_dockerprovider" {
  statement_id  = "AllowExecuteLambdaDockerProviderEveryMinute"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sample_dockerprovider.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_minute.arn
}

