resource "aws_lambda_function" "my_lambda_function" {
  function_name = "TFHelloWorldLambda-${var.stack_name}"
  runtime       = "python3.9"
  handler       = "lambda.handler"
  role          = aws_iam_role.lambda_execution_role.arn

  source_code_hash = filebase64sha256("lambda.zip")
  filename         = "lambda.zip"

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.my_website_bucket.bucket
    }
  }
}

resource "aws_lambda_permission" "my_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.my_api_gateway.execution_arn}/*/GET/hello"
}
