variable "instance-size" {
  default = "db.t4g.micro"
}

variable "environment" {}
variable "account" {}
variable "region" {
  default = "us-east-1"
}

variable "service-name" {}
variable "vpc-name" {}

