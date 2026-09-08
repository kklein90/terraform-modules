#### service discovery services should be configured in the service's TF

### Dev environment
## asterkey.local for backend services
resource "aws_service_discovery_private_dns_namespace" "asterkey_local_ecs_namespace" {
  name        = var.env == "development" ? "asterkey.local" : "${var.short-env}.asterkey.local"
  description = "asterkey.local namespace"
  vpc         = data.aws_vpc.vpc1.id

  tags = {
    name      = "asterkey.local"
    usage     = "servicediscovery"
    managment = "terraform"
    owner     = "techops"
  }
}

