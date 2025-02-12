output "api_url" {
  description = "Invoke URL for API Gateway"
  value       = aws_api_gateway_deployment.vpc_api_deployment.invoke_url
}
