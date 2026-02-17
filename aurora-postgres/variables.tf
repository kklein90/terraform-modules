variable "account" {
  description = "prd or stg"
  validation {
    condition     = contains(["prd", "stg"], var.account)
    error_message = "Must be either prd or stg"
  }
}
variable "environment" {
  description = "prd or stg"
  validation {
    condition     = contains(["prd", "stg"], var.environment)
    error_message = "Must specify one of prd or stg"
  }
}

variable "vpc-name" {}
variable "db-master-username" {}
variable "instance-count" {}
variable "instance-class" {}
variable "rds-cluster-azs" {}
variable "region" {}
variable "service-name" {
  description = "alpha only characters"
  validation {
    condition     = can(regex("^[A-Za-z]+$", var.service-name))
    error_message = "Can only contain alpha characters"
  }
}

variable "rds_kms_key" {
  type = map(map(string))
  default = {
    "prd" = {
      us-east-1 = "arn:aws:kms:us-east-1:956927433137:key/4476d7df-9a60-4782-be23-d466bd8707b8"
    }

    "stg" = {
      us-east-1 = "arn:aws:kms:us-east-1:232220244494:key/9236be7a-b7a4-4aca-90b3-c700b021d734"
    }
  }
}
