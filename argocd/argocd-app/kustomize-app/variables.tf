variable "argocd-pw" {}
variable "github-key" {}
variable "repo-url" {}
variable "app-name" {}
variable "env" {
  type    = string
  default = "home"
}


variable "namespace" {
  type    = string
  default = "default"
}

