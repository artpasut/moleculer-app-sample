# Terraform
Terrform is a powerful tool for building infrastrucutre with concepts of IaC.

## Usage
### Provision resources from local
- Modify following `$` parameters in provider block in `main.tf`, or use default aws credentials.
- ```terraform
    provider "aws" {
        region  = $REGION
        profile = $AWS_PROFILE
    }

    terraform {
    required_version = ">= 1.0.0"

    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = ">= 4.00"
        }
    }

    backend "s3" {
        bucket  = $S3_BACKEND_BUCKET
        key     = "states"
        region  = $REGION
        profile = $AWS_PROFILE
    }
    }
    ```
- Adjust values `inject-production.tfvars`, or create new tfvars file.
- Run following commands to start provision resources.
- ```bash
    #initialize terraform.
    terraform init
    #planing what resources will be create by terraform.
    terraform plan -var-file=$TF_VARS_FILE
    #deploy resouces according to plan.
    terraform apply -var-file=$TF_VARS_FILE -auto-approve
    ```
### Provision resources with github actions
- Fork this repository, and enable actions workflows in repository level.
- Create [IAM role OIDC](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services#adding-the-identity-provider-to-aws) for github actions to access AWS account.
- Create repository actions secret name: `IAM_OIDC_ROLE` with value: `$IAM_ROLE_ARN`.
- Create AWS Certificate in region that you want to provision resources.
- Adjust values `inject-production.tfvars`
- PR/Push branch main to repository, github actions should run `terraform` job.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.00 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.58.0 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2_api_service"></a> [ec2\_api\_service](#module\_ec2\_api\_service) | ./modules/ec2 | n/a |
| <a name="module_ec2_calculator_service"></a> [ec2\_calculator\_service](#module\_ec2\_calculator\_service) | ./modules/ec2 | n/a |
| <a name="module_ec2_math_service"></a> [ec2\_math\_service](#module\_ec2\_math\_service) | ./modules/ec2 | n/a |
| <a name="module_ec2_nats_service"></a> [ec2\_nats\_service](#module\_ec2\_nats\_service) | ./modules/ec2 | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./modules/vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ecr_repository.services](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_lb.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_rule.api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.ec2_api_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.ec2_api_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_s3_bucket.scripts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.scripts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_object.script_nats](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.script_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_security_group.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.alb_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.alb_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.alb_ingress_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ssm_parameter.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [template_cloudinit_config.user_data](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/cloudinit_config) | data source |
| [template_file.cloud_init](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.deploy_service](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.user_data](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_info"></a> [alb\_info](#input\_alb\_info) | ALB variables related | <pre>object({<br>    certificate_arn = string<br>    api_domain_name = string<br>  })</pre> | n/a | yes |
| <a name="input_api_service_info"></a> [api\_service\_info](#input\_api\_service\_info) | API service EC2 variables related | <pre>object({<br>    name              = string<br>    service_port      = number<br>    instance_type     = string<br>    key_name          = string<br>    health_check_path = string<br>  })</pre> | n/a | yes |
| <a name="input_calculator_service_info"></a> [calculator\_service\_info](#input\_calculator\_service\_info) | calculator service EC2 variables related | <pre>object({<br>    name          = string<br>    instance_type = string<br>    key_name      = string<br>  })</pre> | n/a | yes |
| <a name="input_math_service_info"></a> [math\_service\_info](#input\_math\_service\_info) | math service EC2 variables related | <pre>object({<br>    name          = string<br>    instance_type = string<br>    key_name      = string<br>  })</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | name of shared resources. | `string` | n/a | yes |
| <a name="input_nats_service_info"></a> [nats\_service\_info](#input\_nats\_service\_info) | NATS service EC2 variables related | <pre>object({<br>    name          = string<br>    service_port  = number<br>    instance_type = string<br>    key_name      = string<br>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to add more | `map(string)` | `{}` | no |
| <a name="input_vpc_info"></a> [vpc\_info](#input\_vpc\_info) | VPC variables related | <pre>object({<br>    cidr              = string<br>    availability_zone = list(string)<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
