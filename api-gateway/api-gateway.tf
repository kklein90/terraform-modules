resource "aws_api_gateway_rest_api" "gateway_1" {
  api_key_source               = "HEADER"
  description                  = var.use-custom-desc == true ? var.custom-desc : "${var.environment}-${var.project}"
  disable_execute_api_endpoint = "true"

  endpoint_configuration {
    types = var.use-custom-domain == true ? ["EDGE"] : ["REGIONAL"]
  }

  minimum_compression_size = "32768"
  name                     = var.api-name

  body = jsondecode(file("{path.module}/${var.api-file}"))
}

resource "aws_api_gateway_deployment" "gateway_1_deployment" {
  rest_api_id = aws_api_gateway_rest_api.gateway_1.id
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.gateway_1.body))
  }
}

resource "aws_api_gateway_stage" "stages" {
  for_each      = toset(var.stages)
  stage_name    = each.key
  rest_api_id   = aws_api_gateway_rest_api.gateway_1.id
  deployment_id = aws_api_gateway_deployment.gateway_1_deployment.id
  variables     = lookup(var.stage-variables, each.key)
}

resource "aws_api_gateway_vpc_link" "vpc_link_1" {
  name        = "vpc-link-${vpc-link-name}"
  description = "VPC link for ${platform}"
  target_arns = [data.aws_lb.internal_alb.arn]
}
