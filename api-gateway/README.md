# API gateway - WIP

Deploys an API gateway and assocaited resources, some of which depend on variables passed in.

**NOTE**:

## Deployed resources

- Api gateway
- custom domain if variable use_custom_domain = true
- route53 record if variable use_custom_domain = true

## Required variables

- account - dev, stg, prd
- environment - dev, stg, prd (aside from prd, all others must have account set to nonprod)
- project
- api-name
- use-custom-desc
- custom-desc
- use-custom-domain
- custom-domain-name
- service-name
- stages
- stage-variables - map
- internal-alb-name - name of existing internal ALB

## Variable details

### service-name

Service name is used to create names for several resources, such as the api gateway or other resource.  
**It is also used as the name of the Postgresql database**.

### Instance-class

This is the instance size for the DB node. Available classes are here [DB Instance class types](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.Types.html).

For nonprod clusters, try to stay in the 'db.t' Burstable series. These are typically sufficient & are cost effective.

### Rds-cluster-az

This list must include 2-3 availability zones, for instance:

    ["us-east-1a", "us-east-1b", "us-east-1c"]
