# elasticache-redis terraform module

This module deploys a Redis instance of Elasticache, in either single node or multi-node cluster,
depending on which is specified via variables. Associated resources are also created.

Source this module from a root/main module

- existing resources will be discovered

\*\*Note: This module reads existing resources as data objects. Review the data-objects.tf file
to familiarize youreself with those objects.

If deploying to any DR environment (ideally after the other env's have had everything imported, or for testing):

- run TF normally

**NOTE**:
Deployment subnets are dynamically looked up based on the presense of a metadata tag named: **usage**:**data**. At least 2 subnets with this tag are required.

## Account access (does it require provider aliases)

- single account access

## Creates

- Single node or multi-node Elasticache Redis cluster
- Cloudwatch log groups (2) (multi-node only)
- Kms key for intra-cluster communication (multi-node only)
- Parameter group
- Security group
- Sunbet group
- SecretsManager secret (multi-node only)

## Required variables

- account
- project
- service
- environment
- vpc-name
- subnet-cidrs - list of subnets that can access this redis instance/cluster, in list notation... ["",""]
- region
- cluster-type - single or multi
- node-type - cache-XX-size
- redis-ver - Must be one of: 2.6,2.8,3.2,4.0,5.0,6.x,7
- shards - defaults to 1

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

- kms-key-alias
- redis-cluster-endpoint
- redis-endpiont
