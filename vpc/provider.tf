provider "aws" {
  region = var.region

  default_tags {
    tags = {
      environment = var.environment
      owner       = "devops"
      management  = "terraform"
    }
  }
}
