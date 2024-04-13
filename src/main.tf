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

#data "aws_iam_policy_document" "role" {
#  statement {
#    effect = "Allow"
#
#    principals {
#      identifiers = ["lambda.amazonaws.com"]
#      type        = "Service"
#    }
#    actions = ["sts:AssumeRole"]
#  }
#}
#
#resource "aws_iam_role" "part_one_role" {
#  assume_role_policy = data.aws_iam_policy_document.role.json
#}
#
#resource "aws_lambda_function" "AWSLambdaFunction" {
#  function_name = "lambda1"
#  role = aws_iam_role.part_one_role.arn
#  filename = "target/"
#}

resource "aws_instance" "app_server" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"
  tags = {
    Name = "ExampleAppServerInstance"
  }
}

resource "aws_api_gateway_rest_api" "HelloWorldAPI" {
  name = "AssignmentAPIGateway"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "HelloWorldResource" {
  parent_id = aws_api_gateway_rest_api.HelloWorldAPI.root_resource_id
  path_part = "HelloWorld"
  rest_api_id = aws_api_gateway_rest_api.HelloWorldAPI.id
}

resource "aws_api_gateway_method" "HelloWorldMethod" {
  authorization = "NONE"
  http_method = "ANY"
  resource_id = aws_api_gateway_resource.HelloWorldResource.id
  rest_api_id = aws_api_gateway_rest_api.HelloWorldAPI.id
}

#resource "aws_api_gateway_integration" "HelloWorldIntegration" {
#  http_method = aws_api_gateway_method.HelloWorldMethod.http_method
#  resource_id = aws_api_gateway_resource.HelloWorldResource.id
#  rest_api_id = aws_api_gateway_rest_api.HelloWorldAPI.id
#  type = "AWS"
#  integration_http_method = "POST"
#  content_handling = "CONVERT_TO_TEXT"
#  uri =
#}
