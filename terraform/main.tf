# Reference Lambda Module (assuming you have a lambda.tf or a lambda module)
module "lambda" {
  source = "./lambda"

  create_vpc_lambda_name = "CreateVPCFunction"
  get_vpc_lambda_name    = "GetVPCFunction"
  auth_lambda_name       = "VPCAuthFunction"
}

# The api_gateway.tf file will automatically use `module.lambda` references.



output "api_gateway_url" {
  description = "API Gateway Invoke URL"
  value       = module.api_gateway.api_url
}
