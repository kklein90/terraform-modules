# RDS Mysql

Deploy a single node RDS Mysql instance. Creates a dedicated subnet-group & security-group. Additionally, creates a random password for the instance management account and saves that password to a SecretsManager secret (no auto-rotate).

**NOTE**:
This module uses variable maps to determine a KMS key ARN, which requires both an account name & a the deployment region. Further, the KMS key ARN for the target region must be configured in the variable map prior to deployment of this module.

DO NOT use this module for any production, mission critical services, it's a single instance & therefore
not resilient.

Deployment subnets are dynamically looked up based on the presense of a metadata tag named: **usage**:**data**. At least 2 subnets with this tag are required.

This module will grant access to the entire VPC CIDR block via the created security group. adjust as needed...

## Deployed resources

- RDS Mysql instance (stand along)
- Security group
- Subnet group
- SecretsManager secret w/random password

## Required variables

- account - production or nonprod only
- env - prod, dev, demo, qa, uat (aside from prod, all others must have account set to nonprod)
- instance-class - the instance size [DB Instance class types](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.Types.html) (defaults to t4g.micro)
- region - AWS region (defaults to us-east-1)
- service-name - the name of your service, e.g. microservice1, nginx, icecream, etc...
- vpc-name

## Variable details

### service-name

Service name is used to create names for several resources, such as the cluster & nodes, the security group.  
**It is also used as the name of the Mysql database**.

### Instance-class

This is the instance size for the DB node. Available classes are here [DB Instance class types](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.Types.html).

For nonprod clusters, try to stay in the 'db.t' Burstable series. These are typically sufficient & are cost effective.
