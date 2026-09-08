variable "env" {}

# standardizing tag values
variable "standard-env" {
  type = map(string)
  default = {
    dev   = "develop"
    stage = "stage"
    prod  = "prod"
  }
}

variable "short-env" {}

variable "vpc_id" {}

variable "account" {}

variable "prod_id" {
  default = "380735047240"
}

variable "dev_id" {
  default = "228923425684"
}

variable "stage_id" {
  default = "464677946080"
}

variable "region" {}

variable "regional-bucket-access-account-id" {}
