variable "account" {
  description = "dev, prd or stg"
  validation {
    condition     = contains(["prd", "stg", "dev"], var.account)
    error_message = "Must be either dev, prd or stg"
  }
}
variable "environment" {
  description = "dev, prd or stg"
  validation {
    condition     = contains(["prd", "stg", "dev"], var.environment)
    error_message = "Must specify one of dev, prd or stg"
  }
}
variable "vpc-name" {}
variable "project" {}
variable "service" {}
variable "api-name" {}
variable "use-custom-desc" {}
variable "custom-desc" {
  default = "none"
}
variable "use-custom-domain" {
  default = false
}

variable "custom-domain-name" {
  default = "none"
}

variable "api-file" {}

variable "stages" {
  type = list(any)
}

variable "stage-variables" {
  type = map(object({
    "carouselSlidesKey"     = string
    "corsAuthorizedDomain"  = string
    "endpointUrlCourses"    = string
    "endpointUrlFoundation" = string
    "vpcLinkIdCourses"      = ""
    "vpcLinkIdFoundation"   = ""
  }))
}

variable "internal-alb-name" {}

locals {
  cust-domain-parts = split(".", var.custom-domain-name)
  parts-len         = length(local.cust-domain-parts)
  domain-parts      = slice(local.cust-domain-parts, local.parts-len - 2, local.parts-len)
  domain-name       = join(".", local.domain-parts)
}
