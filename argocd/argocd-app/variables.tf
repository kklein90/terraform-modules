variable "account-id" {
  type = map(string)
  default = {
    ops = "871697377499"
    stg = "232220244494"
    prd = "956927433137"
  }
}

variable "app_name" {
  type = string
}

variable "cluster_info" {
  type = object({
    cluster_name = string
    environment  = string
  })
}

variable "namespace" {
  type    = string
  default = "default"
}

variable "create_namespace" {
  type    = bool
  default = false
}

variable "repo_url" {
  type = string
}

variable "target_revision" {
  type = string
}

variable "chart" {
  type    = string
  default = null
}

variable "path" {
  type    = string
  default = null
}

variable "values" {
  type    = string
  default = null
}

variable "values_to_parameters" {
  type    = any
  default = null
}

variable "images" {
  type        = list(string)
  default     = null
  description = "kustomize.images value"
}

variable "parameters" {
  type = list(object({
    name  = string
    value = any
  }))
  default = null
}

variable "values_object" {
  type    = any
  default = null
}

variable "value_files" {
  type    = list(string)
  default = null
}
