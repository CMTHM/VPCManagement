# Define the API Gateway REST API
resource "aws_api_gateway_rest_api" "vpc_api" {
  name = "VPCManagementAPI"
}

# Create a resource for /create-vpc
resource "aws_api_gateway_resource" "create_vpc" {
  rest_api_id = aws_api_gateway_rest_api.vpc_api.id
  parent_id   = aws_api_gateway_rest_api.vpc_api.root_resource_id
  path_part   = "create-vpc"
}

# POST method for /create-vpc with Lambda authorizer
resource "aws_api_gateway_method" "create_vpc_post" {
  rest_api_id   = aws_api_gateway_rest_api.vpc_api.id
  resource_id   = aws_api_gateway_resource.create_vpc.id
  http_method   = "POST"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.vpc_auth.id  # Attach the Lambda authorizer
}

# Integration for POST method
resource "aws_api_gateway_integration" "create_vpc_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.vpc_api.id
  resource_id            = aws_api_gateway_resource.create_vpc.id
  http_method            = aws_api_gateway_method.create_vpc_post.http_method
  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = aws_lambda_function.create_vpc_lambda.invoke_arn
}

# Create a resource for /get-vpc
resource "aws_api_gateway_resource" "get_vpc" {
  rest_api_id = aws_api_gateway_rest_api.vpc_api.id
  parent_id   = aws_api_gateway_rest_api.vpc_api.root_resource_id
  path_part   = "get-vpc"
}

# Create a resource for /get-vpc/{vpc_id}
resource "aws_api_gateway_resource" "get_vpc_id" {
  rest_api_id = aws_api_gateway_rest_api.vpc_api.id
  parent_id   = aws_api_gateway_resource.get_vpc.id
  path_part   = "{vpc_id}"
}

# GET method for /get-vpc/{vpc_id} with Lambda authorizer
resource "aws_api_gateway_method" "get_vpc_get" {
  rest_api_id   = aws_api_gateway_rest_api.vpc_api.id
  resource_id   = aws_api_gateway_resource.get_vpc_id.id
  http_method   = "GET"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.vpc_auth.id  # Attach the Lambda authorizer
}

# Integration for GET method
resource "aws_api_gateway_integration" "get_vpc_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.vpc_api.id
  resource_id            = aws_api_gateway_resource.get_vpc_id.id
  http_method            = aws_api_gateway_method.get_vpc_get.http_method
  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = aws_lambda_function.get_vpc_lambda.invoke_arn
}

# API Gateway Authorizer for Token-based authentication
resource "aws_api_gateway_authorizer" "vpc_auth" {
  name                = "VPCAuthorizer"
  rest_api_id         = aws_api_gateway_rest_api.vpc_api.id
  type                = "TOKEN"
  identity_source     = "method.request.header.Authorization"
  authorizer_uri      = aws_lambda_function.auth_lambda.invoke_arn
}

# Create the API Gateway deployment
resource "aws_api_gateway_deployment" "vpc_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.vpc_api.id
  depends_on  = [
    aws_api_gateway_method.create_vpc_post,
    aws_api_gateway_method.get_vpc_get,
    aws_api_gateway_integration.create_vpc_lambda,
    aws_api_gateway_integration.get_vpc_lambda
  ]
}

# API Gateway Stage (explicitly defined)
resource "aws_api_gateway_stage" "vpc_api_stage" {
  stage_name    = "prod"
  rest_api_id  = aws_api_gateway_rest_api.vpc_api.id
  deployment_id = aws_api_gateway_deployment.vpc_api_deployment.id
}

# Lambda permissions for API Gateway to invoke functions
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
