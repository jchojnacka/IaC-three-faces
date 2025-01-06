resource "aws_api_gateway_rest_api" "my_api_gateway" {
  name = "TFHelloWorldApi-${var.stack_name}"
}

resource "aws_api_gateway_resource" "my_api_gateway_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.my_api_gateway.root_resource_id
  path_part   = "hello"
}

resource "aws_api_gateway_method" "my_api_gateway_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api_gateway.id
  resource_id   = aws_api_gateway_resource.my_api_gateway_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "my_api_gateway_integration" {
  rest_api_id             = aws_api_gateway_rest_api.my_api_gateway.id
  resource_id             = aws_api_gateway_resource.my_api_gateway_resource.id
  http_method             = aws_api_gateway_method.my_api_gateway_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.my_lambda_function.invoke_arn
}

resource "aws_api_gateway_deployment" "my_api_deployment" {
  depends_on = [aws_api_gateway_integration.my_api_gateway_integration]
  rest_api_id = aws_api_gateway_rest_api.my_api_gateway.id
}

resource "aws_api_gateway_stage" "my_api_stage" {
  deployment_id = aws_api_gateway_deployment.my_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.my_api_gateway.id
  stage_name    = "prod"
}