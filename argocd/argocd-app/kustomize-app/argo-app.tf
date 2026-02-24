## default project should already exist
# resource "argocd_project" "default" {
#   metadata {
#     name      = "default"
#     namespace = "argocd"
#   }

#   spec {
#     # description  = "Default ArgoCD project"
#     source_repos = ["*"]

#     destination {
#       server    = "https://kubernetes.default.svc"
#       namespace = "default"
#     }

#     cluster_resource_whitelist {
#       group = "*"
#       kind  = "*"
#     }
#   }
# }

resource "argocd_repository" "repo" {
  repo            = var.repo-url
  name            = var.app-name
  type            = "git"
  ssh_private_key = var.github-key
  project         = "default"
}

resource "argocd_application" "application" {
  metadata {
    name      = var.app-name
    namespace = var.namespace
  }

  spec {
    project = "default"

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = var.namespace
      #   name      = "n8n" # conflicts with server param
    }

    source {
      repo_url        = var.repo-url
      path            = "infra/kubernetes/overlays/${var.env}"
      target_revision = "main"
    }

    sync_policy {
      automated {
        prune       = true
        self_heal   = true
        allow_empty = true
      }
      sync_options = ["Validate=false"]
      retry {
        limit = "5"
        backoff {
          duration     = "30s"
          max_duration = "2m"
          factor       = "2"
        }
      }
    }
  }

  depends_on = [argocd_repository.repo]
}
