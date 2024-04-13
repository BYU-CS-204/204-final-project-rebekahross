terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}
provider "aws" {
  shared_config_files = ["/Users/rebekahross/.aws/config"]
  shared_credentials_files = ["/Users/rebekahross/.aws/credentials"]
  region = "us-west-2"
}

data "aws_iam_policy_document" "role" {
  statement {
    effect = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "part_one_role" {
  assume_role_policy = data.aws_iam_policy_document.role.json
}

resource "aws_lambda_function" "lambda_functions" {
  for_each = var.lambda
  role = aws_iam_role.part_one_role.arn

  function_name = each.key
  filename = "../target/module-14.jar"
  runtime = "java17"
  handler = each.value.handler

  source_code_hash = "filebase64sha256(../target/module-14.jar)"
}


resource "aws_api_gateway_rest_api" "HelloWorldAPI" {
  name = "AssignmentAPIGateway"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "HelloWorldResource" {
  for_each = var.lambda
  parent_id = aws_api_gateway_rest_api.HelloWorldAPI.root_resource_id
  path_part = each.key
  rest_api_id = aws_api_gateway_rest_api.HelloWorldAPI.id
}

resource "aws_api_gateway_method" "HelloWorldMethod" {
  for_each = aws_api_gateway_resource.HelloWorldResource
  resource_id = each.value.id

  authorization = "NONE"
  http_method = "ANY"
  rest_api_id = aws_api_gateway_rest_api.HelloWorldAPI.id
  depends_on = [aws_lambda_function.lambda_functions]
}

resource "aws_api_gateway_integration" "HelloWorldIntegration" {
  for_each = aws_api_gateway_resource.HelloWorldResource
  resource_id = each.value.id

  http_method = aws_api_gateway_method.HelloWorldMethod[each.key].http_method
  rest_api_id = aws_api_gateway_rest_api.HelloWorldAPI.id
  type = "AWS"
  integration_http_method = "POST"
  content_handling = "CONVERT_TO_TEXT"
  uri = aws_lambda_function.lambda_functions[each.key].invoke_arn
  depends_on = [aws_lambda_function.lambda_functions]
}

resource "aws_api_gateway_method_response" "method_response_200" {
  for_each = aws_api_gateway_resource.HelloWorldResource
  resource_id = each.value.id
  http_method = aws_api_gateway_method.HelloWorldMethod[each.key].http_method
  rest_api_id = aws_api_gateway_rest_api.HelloWorldAPI.id
  status_code = "200"
  response_models = {"application/json" = "Empty"}
}

resource aws_api_gateway_integration_response "HelloWorldIntegrationResponse" {
  for_each = aws_api_gateway_resource.HelloWorldResource
  resource_id = each.value.id
  http_method = aws_api_gateway_method.HelloWorldMethod[each.key].http_method
  rest_api_id = aws_api_gateway_rest_api.HelloWorldAPI.id
  status_code = aws_api_gateway_method_response.method_response_200[each.key].status_code
  depends_on = [time_sleep.wait_30_seconds]
}

resource "time_sleep" "wait_30_seconds" {
  create_duration = "30s"
}

resource "aws_api_gateway_deployment" "HelloWorldDeployment" {
  rest_api_id = aws_api_gateway_rest_api.HelloWorldAPI.id
  stage_name = "test"
  depends_on = [aws_api_gateway_integration.HelloWorldIntegration, aws_api_gateway_integration_response.HelloWorldIntegrationResponse, aws_api_gateway_method_response.method_response_200]
}

resource "aws_lambda_permission" "LambdaPermission" {
  for_each = aws_lambda_function.lambda_functions
  action = "lambda:InvokeFunction"
  function_name = each.value.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.HelloWorldAPI.execution_arn}/*"
}