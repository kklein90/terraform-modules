terraform {
  required_version = ">= 1.3"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.16"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = ">= 7.13.0"
    }
  }
}

provider "argocd" {
  server_addr = "argo.kwkc.xyz:443"
  username    = "admin"
  password    = var.argocd-pw
  insecure    = false
  ## when accesing argocd via kube proxy
  # server_addr = "localhost:8088"
  # plain_text  = true
}
