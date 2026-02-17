# VPC terraform module

Source this module from a root/main module - existing resources will be discovered

**NOTE:** the data sources (existing resources) and the matching imported resources will not clash or cause issues.

This module creates multiple subnets with incrementing subnet numbers based off the provided CIDR block. Review the subnets.tf file
to ensure you your CIDR block has enough space.

If deploying to any DR environment (ideally after the other env's have had everything imported, or for testing):

- run TF normally

## Account access (does it require provider aliases)

- single

## Creates

- VPC
- Subnets
    - 2 public subnets
    - 3 private app subnets
    - 3 private data subnets
- Routes & route tables
- Internet gateway
- NAT gateway w/EIP

## Required variables

- project
    - one of samcart-ops, samcart-prd, samcart-stg, dr-samcart-ops, dr-samcart-prd, dr-samcart-stg
- domain-name
    - defaults to ec2.internal
- environment - for instance, prd, dev, stg
- project - project name (will be used to name VPC, among other things)
- region - AWS region you're deploying to

## Data sources

This module identifies the following existing resources, based on the project variable:

- VPC Id
- IGW Id
- NATGW Id
- Peering connection ID

## Outputs

- vpc_id
- nat_ip - NAT gateway public IP (elastic IP)
