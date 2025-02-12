resource "aws_lambda_function" "create_vpc_lambda" {
  function_name = "CreateVPCFunction"
  runtime       = "python3.9"
  handler       = "index.lambda_handler"
  role          = aws_iam_role.lambda_exec_role.arn

  filename         = "create_vpc.zip"
  source_code_hash = filebase64sha256("create_vpc.zip")
}

resource "aws_lambda_function" "get_vpc_lambda" {
  function_name = "GetVPCFunction"
  runtime       = "python3.9"
  handler       = "index.lambda_handler"
  role          = aws_iam_role.lambda_exec_role.arn

  filename         = "get_vpc.zip"
  source_code_hash = filebase64sha256("get_vpc.zip")
}

resource "aws_lambda_function" "auth_lambda" {
  function_name = "VPCAuthFunction"
  runtime       = "python3.9"
  handler       = "index.lambda_handler"
  role          = aws_iam_role.lambda_exec_role.arn

  filename         = "auth.zip"
  source_code_hash = filebase64sha256("auth.zip")
}
