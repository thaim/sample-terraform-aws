# 動作確認のため，各lambda関数を毎分呼び出す
resource "aws_cloudwatch_event_rule" "every_minute" {
  name                = "every-minute"
  description         = "invoke event every minute"
  schedule_expression = "cron(* * * * ? *)"
}

resource "aws_lambda_permission" "allow_cloudwatch_invoke_lambda_prepared" {
  statement_id  = "AllowExecuteLambdaPreparedEveryMinute"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sample_prepared.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_minute.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_invoke_lambda_localexec" {
  statement_id  = "AllowExecuteLambdaLocalexecEveryMinute"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sample_localexec.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_minute.arn
}

