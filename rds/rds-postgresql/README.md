# postgres terraform module

This module deploys a PostgreSQL cluster and associated infrastructure.<br>
**NOTE:** this is NOT for deploying an AWS **Aurora** PostgreSQL database!

Source this module from a root/main module

- existing resources will be discovered

\*\*Note: This module reads existing resources as data objects. Review the data-objects.tf file
to familiarize youreself with those objects.

Deployment subnets are dynamically looked up based on the presense of a metadata tag named: **usage**:**data**. At least 2 subnets with this tag are required.

If deploying to any DR environment (ideally after the other env's have had everything imported, or for testing):

- run TF normally

## Account access (does it require provider aliases)

- single account access

## Creates

- PostreSQL cluster - default user is postgres
- PostgreSQL cluster instances as specified
- Subnet group
- Security group - allows access from local app & data subnet CIDR blocks only
- KMS key for database encryption
- SecretsManger secret to store the randomly generated password

## Required variables

- service - e.g. typeset, foundation, courses
- environment - prd or stg
- vpc-name
- region - defaults to us-east-1, specify another if needed
- pg-ver - postgresql version - dafaults to 17.6 (available vers here: `aws rds describe-db-engine-versions --filters Name=engine,Values=postgres --query DBEngineVersions[].[Engine,EngineVersion]`)
- database-name - the name of the primary database for the service
- instance-class - the size of the instances, e.g. t4g.large (defaults to t4g.small)
- instance-count - number of cluster instances to provision

## Data sources

This module identifies the following existing resources, based on the project variable:

- AWS current region
- Available AZ's
- VPC Id
- Subnets (data, app & public)

## Outputs

- secret-name
- cluster-identifier
- cluster-endpoint
- kms-key-alias
