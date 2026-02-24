# argocd-app terraform module

Create Argocd resources, including cluster deployment & apps for either helm or kustomize deployment

If deploying to any DR environment (ideally after the other env's have had everything imported, or for testing):

- run TF normally

## Account access (does it require provider aliases)

- << single or multiple >>

<< if multiple, descibe which accounts and how providers are determined. >>

## Creates

- Argocd repo (github)
- Argocd application

### argocd-app

**NOTE: this is not for deploying ArgoCD, only your apps to an existing ArgoCD instance.**

- deployable application configured in Argocd ()

## Required variables

- argocd-pw : as named
- github-key : SSH key for accessing github repo
- repo-url : repo URL (ssh)
- app-name : name of the app in Argocd
- env : kustomize overlay directory
- namespace : K8s namespace to deploy app to

## Data sources

This module identifies the following existing resources, based on the project variable:

- nonoe

## Outputs

- << add list of outputs >>
