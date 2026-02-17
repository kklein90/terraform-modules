terraform {
  required_providers {
    aws = {
      configuration_aliases = [
        aws.dev,
        aws.stg,
        aws.prd
      ]
    }
  }
}
