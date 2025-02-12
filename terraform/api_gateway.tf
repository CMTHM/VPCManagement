resource "aws_api_gateway_rest_api" "vpc_api" {
  name = "VPCManagementAPI"
}

resource "aws_api_gateway_resource" "create_vpc" {
  rest_api_id = aws_api_gateway_rest_api.vpc_api.id
  parent_id   = aws_api_gateway_rest_api.vpc_api.root_resource_id
  path_part   = "create-vpc"
}

resource "aws_api_gateway_method" "create_vpc_post" {
  rest_api_id   = aws_api_gateway_rest_api.vpc_api.id
  resource_id   = aws_api_gateway_resource.create_vpc.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "create_vpc_lambda" {
  rest_api_id = aws_api_gateway_rest_api.vpc_api.id
  resource_id = aws_api_gateway_resource.create_vpc.id
  http_method = aws_api_gateway_method.create_vpc_post.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = aws_lambda_function.create_vpc_lambda.invoke_arn
}

resource "aws_api_gateway_resource" "get_vpc" {
  rest_api_id = aws_api_gateway_rest_api.vpc_api.id
  parent_id   = aws_api_gateway_rest_api.vpc_api.root_resource_id
  path_part   = "get-vpc"
}

resource "aws_api_gateway_resource" "get_vpc_id" {
  rest_api_id = aws_api_gateway_rest_api.vpc_api.id
  parent_id   = aws_api_gateway_resource.get_vpc.id
  path_part   = "{vpc_id}"
}

resource "aws_api_gateway_method" "get_vpc_get" {
  rest_api_id   = aws_api_gateway_rest_api.vpc_api.id
  resource_id   = aws_api_gateway_resource.get_vpc_id.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_vpc_lambda" {
  rest_api_id = aws_api_gateway_rest_api.vpc_api.id
  resource_id = aws_api_gateway_resource.get_vpc_id.id
  http_method = aws_api_gateway_method.get_vpc_get.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = aws_lambda_function.get_vpc_lambda.invoke_arn
}

resource "aws_api_gateway_authorizer" "vpc_auth" {
  name          = "VPCAuthorizer"
  rest_api_id   = aws_api_gateway_rest_api.vpc_api.id
  type          = "TOKEN"
  identity_source = "method.request.header.Authorization"
  authorizer_uri = aws_lambda_function.auth_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "vpc_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.vpc_api.id
  stage_name  = "prod"
}

resource "aws_lambda_permission" "create_vpc_permission" {
  statement_id  = "AllowExecutionFromAPIGatewayCreateVPC"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_vpc_lambda.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_lambda_permission" "get_vpc_permission" {
  statement_id  = "AllowExecutionFromAPIGatewayGetVPC"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_vpc_lambda.function_name
  principal     = "apigateway.amazonaws.com"
}
