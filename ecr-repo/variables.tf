variable "account" {}
variable "service" {}
variable "environment" {}
variable "region" {
  default = "us-east-1"
}

variable "container-repos" {
  type = list(string)
}

variable "permitted-arns" {
  type = list(string)
}

variable "account-id" {
  type = map(string)
  default = {
    ops = "871697377499"
    stg = "232220244494"
    prd = "956927433137"
  }
}

output "repos" {
  value = var.container-repos
}
