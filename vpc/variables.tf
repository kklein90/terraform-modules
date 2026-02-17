
variable "environment" {}
variable "region" {}
variable "project" {}

variable "domain-name" {
  default = "ec2.internal"
}

variable "vpc-name" {
  type    = string
  default = "vpc-01"
}

variable "vpc-cidr" {
  type    = string
  default = "10.1.0.0/16"
}



