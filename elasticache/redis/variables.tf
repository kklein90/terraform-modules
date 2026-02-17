variable "account" {}
variable "project" {}
variable "service" {}
variable "environment" {}
variable "region" {}
variable "vpc-name" {}

variable "account-id" {
  default = data.aws_caller_identity.current.account_id
}

variable "cluster-type" {
  type    = string
  default = "single"

  validation {
    condition     = can(regex("^(single|multi)$", var.cluster-type))
    error_message = "Must be one of: 'single' | 'multi'"
  }

}

variable "node-type" {
  default = "cache-t4g.micro"
}

variable "redis-ver" {
  type    = string
  default = "7"

  validation {
    condition     = can(regex("^(2.6|2.8|3.2|4.0|5.0|6.x|7)$", var.redis-ver))
    error_message = "Must be one of: 2.6,2.8,3.2,4.0,5.0,6.x,7"
  }
}

variable "shards" {
  default = 1
}

# list of subnet cidrs for each environment that need access to this rds cluster
variable "subnet-cidrs" {
  type = list(string)
  }
}
