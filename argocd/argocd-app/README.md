# argocd-app terraform module

\*\*Note: This module reads existing resources as data objects. Review the data-objects.tf file
to familiarize youreself with those objects.

If deploying to any DR environment (ideally after the other env's have had everything imported, or for testing):

- run TF normally

## Account access (does it require provider aliases)

- << single or multiple >>

<< if multiple, descibe which accounts and how providers are determined. >>

## Creates

### argocd-app

**NOTE: this is not for deploying ArgoCD, only your apps to an existing ArgoCD instance.**

- deployable application configured in Argocd ()

## Required variables

- << add bulleted list of required vairables, with description & validation requirements >>

## Data sources

This module identifies the following existing resources, based on the project variable:

- AWS current region
- Available AZ's
- VPC Id
- IGW Id
- NATGW Id
- Peering connection ID
- Subnets (data, app & public)
- << add any addition data look ups you create >>

## Outputs

- << add list of outputs >>
