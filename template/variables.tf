variable "account" {}
variable "project" {}
variable "service" {}
variable "environment" {}
variable "region" {
  default = "us-east-1"
}
variable "vpc-name" {}

variable "account-id" {
  type = string
}
