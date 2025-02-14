resource "aws_lambda_function" "create_vpc_lambda" {
  function_name = "CreateVPCFunction"
  runtime       = "python3.9"
  handler       = "create_vpc.lambda_handler"
  role          = aws_iam_role.lambda_execution_role.arn

  filename         = "lambda/create_vpc.zip"
  source_code_hash = filebase64sha256("lambda/create_vpc.zip")
  depends_on = [
    aws_iam_role_policy_attachment.lambda_policy_attach
  ]
}

resource "aws_lambda_function" "get_vpc_lambda" {
  function_name = "GetVPCFunction"
  runtime       = "python3.9"
  handler       = "get_vpc.lambda_handler"
  role          = aws_iam_role.lambda_execution_role.arn

  filename         = "lambda/get_vpc.zip"
  source_code_hash = filebase64sha256("lambda/get_vpc.zip")
  depends_on = [
    aws_iam_role_policy_attachment.lambda_policy_attach
  ]
}

resource "aws_lambda_function" "auth_lambda" {
  function_name = "VPCAuthFunction"
  runtime       = "python3.9"
  handler       = "auth_lambda.lambda_handler"
  role          = aws_iam_role.lambda_execution_role.arn

  filename         = "lambda/auth_lambda.zip"
  source_code_hash = filebase64sha256("lambda/auth_lambda.zip")
  depends_on = [
    aws_iam_role_policy_attachment.lambda_policy_attach
  ]
}
