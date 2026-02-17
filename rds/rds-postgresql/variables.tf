variable "account" {}
variable "project" {}
variable "service" {}
variable "environment" {}
variable "region" {}
variable "vpc-name" {}

variable "account-id" {
  default = data.aws_caller_identity.current.account_id
}

# list of subnet cidrs for each environment that need access to this rds cluster
variable "subnet-cidrs" {
  type = map(list(string))
  default = {
    ops = ["10.1.4.0/23", "10.1.6.0/23", "10.1.8.0/23", "10.1.10.0/23", "10.1.12.0/23", "10.1.14.0/23"]
    stg = ["10.2.4.0/23", "10.2.6.0/23", "10.2.8.0/23", "10.2.10.0/23", "10.2.12.0/23", "10.2.14.0/23"]
    prd = ["10.101.4.0/23", "10.101.6.0/23", "10.101.8.0/23", "10.101.10.0/23", "10.101.12.0/23", "10.101.14.0/23"]
  }
}

variable "database-name" {}
variable "instance-class" {
  default = "t4g.small"
}
variable "instance-count" {
  default = 1
}

variable "pg-ver" {
  default = "17.6"
}

