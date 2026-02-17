# RDS for API module

Deploy a single node RDS Aurora (PostgreSQL) cluster. Creates a dedicated subnet-group & security-group. Additionally, creates a random password for the cluster management account and saves that password to a SecretsManager secret (no auto-rotate).

**NOTE**:
This module uses variable maps to determine a KMS key ARN, which requires both an account name & a the deployment region. Further, the KMS key ARN for the target region must be configured in the variable map prior to deployment of this module.

Deployment subnets are dynamically looked up based on the presense of a metadata tag named: **usage**:**data**. At least 2 subnets with this tag are required.

## Deployed resources

- RDS Aurora Cluster
- RDS Aurora Cluster instance (1)
- Security group
- Subnet group
- SecretsManager secret w/random password

## Required variables

- account - production or nonprod only
- env - prod, dev, demo, qa, uat (aside from prod, all others must have account set to nonprod)
- instance-count - number of cluster node instances
- instance-class - the instance size [DB Instance class types](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.Types.html)
- rds-cluster-azs - list of availability zones in the region you're deploying to, e.g. ["us-east-1a", "us-east-1b", "us-east-1c"]
- region - AWS region
- service-name - the name of your service, e.g. foundation, kong, icecream
- vpc-name - name of VPC to deploy to

## Variable details

### service-name

Service name is used to create names for several resources, such as the Aurora cluster & nodes, the security group.  
**It is also used as the name of the Postgresql database**.

### Instance-class

This is the instance size for the DB node. Available classes are here [DB Instance class types](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.Types.html).

For nonprod clusters, try to stay in the 'db.t' Burstable series. These are typically sufficient & are cost effective.

### Rds-cluster-az

This list must include 2-3 availability zones. For Mural's purposes, a,b & c are typically used. That would result in the following entry:

    ["us-east-1a", "us-east-1b", "us-east-1c"]
