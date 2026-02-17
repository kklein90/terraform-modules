# terraform-modules

Each module folder will include a README with descriptions of required and optional variables. You must provide ALL **required** variables, either in your root module, in a TF_VARS file, or on the command line. Optional variables are indicated by the presense of a default value.

## Contributing

### Setup

The template directory contains a script that will 'seed' your new module directory with:

- README.md template that you should edit
- data-objects.tf that contains standard data object lookups, add to this as needed for your project
- variables.tf that contains standard variables, add to this as needed for your project

To create a skeleton project, create a directory for you new module, **cd** into it and run:

    ../template/tf-module-setup.sh <module-name>         <--- adjust the path as needed.

## Sourcing the modules in this repo

### Running locally (don't)

Several of the modules in this repo can require cross-account access to deploy all resources.

<span style="color:red"><strong>If a module requires access to multiple accounts it will be noted in the README, in the Account Access section.</strong></span>

To achieve this, you must specify multiple **AWS** Terraform providers, each specifying the account assumable role & an alias, then you must pass those aliases to the module.

NOTE: these are **REQUIRED** only for the modules in this repo that are marked as **multi-account access** in its' README.

#### Define alternate, 'alias', providers:

    provider "aws" {                <--- default provider (no alias needed)
        region  = "us-east-1"       <--- specify the region you want to deploy to here
        assume_role {
            role_arn = "arn:aws:iam::123456789123:role/OrganizationAccountAccessRole"
        }
      }

    provider "aws" {                <--- alternate account provider w/alias
        alias   = "stg"
        region  = "us-east-1"
        assume_role {
            role_arn = "arn:aws:iam::987456321456:role/OrganizationAccountAccessRole"
        }
      }

        ...
    }

#### Pass the **alias** providers to the module:

    module "ecs-svc" {
        source = "git@github.com:samcart/sc-tf-modules.git//vpc"   <--- double-slash+folder name
        providers = {
            aws.prd    = aws.prd
            aws.stg = aws.stg
    }

#### Receive the aliases in the module:

To "receive" the aliased within a module, there must be an alias "proxy", in the form of a
**Terraform** block, in the module:

    terraform {
    required_providers {
        aws = {
            configuration_aliases = [
                aws.ops,
                aws.prd,
                aws.stg
            ]
        }
      }
    }

### Calling modules in this repo

In order to use a specific module in this repository, you must append a double-slash + folder name to the git repo string:

    module "ecs-svc" {
        source = "git@github.com:kklein90/terraform-modules.git//vpc"   <--- double-slash+folder name
        providers = {
            aws.prod    = aws.prd
            aws.nonprod = aws.stg
        }
        project = "compute-01"
        vpc-cidr = "10.100.0.0/20"
        domain-name = "domain.name"
    }
