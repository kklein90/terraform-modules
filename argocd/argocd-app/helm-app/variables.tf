variable "argocd-pw" {}

variable "repo-url" {}
variable "app-name" {}

variable "namespace" {
  type    = string
  default = "default"
}

variable "chart-name" {
  type = string
}

variable "chart-revision" {}
variable "release-name" {}
variable "values-files" {
  type = list(any)
}

