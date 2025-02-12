variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_table_name" {
  description = "DynamoDB table for storing VPC records"
  default     = "VPCRecords"
}
