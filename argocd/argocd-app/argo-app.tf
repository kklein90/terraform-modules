resource "kubernetes_namespace_v1" "default" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.namespace
  }
}

resource "kubectl_manifest" "default" {
  yaml_body = yamlencode({
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = var.app_name
      namespace = "argocd"
      finalizers = [
        "resources-finalizer.argocd.argoproj.io"
      ]
    }
    spec = {
      project = "default"
      destination = {
        name      = var.cluster_info.cluster_name
        namespace = var.namespace
      }
      source = {
        repoURL        = var.repo_url
        targetRevision = var.target_revision
        chart          = var.chart
        path           = var.path
        # helm settings are only needed if this is helm and not kustomize
        helm = {
          values       = var.values
          valueFiles   = var.value_files
          valuesObject = var.values_object
          parameters   = var.parameters
        }
        kustomize = {
          images = var.images
        }
      }
      syncPolicy = {
        automated = {}
      }
    }
  })
}
