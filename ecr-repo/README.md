# ecr-repo terraform module

This module deploys an ECR container repository and associated permissions & lifecycle policies.
Source this module from a root/main module - existing resources will be discovered

\*\*Note: This module reads existing resources as data objects. Review the data-objects.tf file
to familiarize youreself with those objects.

If deploying to any DR environment (ideally after the other env's have had everything imported, or for testing):

- run TF normally

## Account access (does it require provider aliases)

- single account access

## Creates

- ECR repository
- Access policy
- Lifecycle policy

## Required variables

- account
- service
- environment
- region - defaults to us-east-1
- container-repos - list of repos to create in the format: ["repo1","repo2"...] (can be just a single repo)
- permitted-arns - list of ARNs that required access to the ECR repositories.

## Data sources

This module identifies the following existing resources, based on the project variable:

- AWS current region
- Available AZ's
- VPC Id
- IGW Id
- NATGW Id
- Peering connection ID
- Subnets (data, app & public)

## Outputs

- none
