provider "aws" {
  region = "ap-southeast-1"
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
    bucket = "terraform-states-r6hjtxh"
    key    = "states"
    region = "ap-southeast-1"
  }
}

module "vpc" {
  source            = "./modules/vpc"
  name              = var.name
  vpc_cidr          = var.vpc_info.cidr
  availability_zone = var.vpc_info.availability_zone
  tags              = var.tags
}

module "ec2_api_service" {
  source = "./modules/ec2"
  name   = var.api_service_info.name
  security_group_ingress_rules = {
    allow_from_https = {
      port                     = var.api_service_info.service_port
      source_security_group_id = aws_security_group.alb.id
    }
  }
  security_group_egress_rules = {
    allow_to_all = {
      port             = "0"
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }
  ami           = "ami-05c8486d62efc5d07"
  instance_type = var.api_service_info.instance_type
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.private_subnet_ids[0]
  user_data     = data.template_cloudinit_config.user_data.rendered
  key_name      = var.api_service_info.key_name
  tags          = var.tags
}

module "ec2_calculator_service" {
  source = "./modules/ec2"
  name   = var.calculator_service_info.name
  security_group_ingress_rules = {

  }
  security_group_egress_rules = {
    allow_to_all = {
      port             = "0"
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }
  ami           = "ami-05c8486d62efc5d07"
  instance_type = var.calculator_service_info.instance_type
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.private_subnet_ids[0]
  user_data     = data.template_cloudinit_config.user_data.rendered
  key_name      = var.calculator_service_info.key_name
  tags          = var.tags
}

module "ec2_math_service" {
  source = "./modules/ec2"
  name   = var.math_service_info.name
  security_group_ingress_rules = {

  }
  security_group_egress_rules = {
    allow_to_all = {
      port             = "0"
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }
  ami           = "ami-05c8486d62efc5d07"
  instance_type = var.math_service_info.instance_type
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.private_subnet_ids[0]
  user_data     = data.template_cloudinit_config.user_data.rendered
  key_name      = var.math_service_info.key_name
  tags          = var.tags
}

module "ec2_nats_service" {
  source = "./modules/ec2"
  name   = var.nats_service_info.name
  security_group_ingress_rules = {
    allow_from_api = {
      port                     = var.nats_service_info.service_port
      source_security_group_id = module.ec2_api_service.security_group_id
    }
    allow_from_calculator = {
      port                     = var.nats_service_info.service_port
      source_security_group_id = module.ec2_calculator_service.security_group_id
    }
    allow_from_math = {
      port                     = var.nats_service_info.service_port
      source_security_group_id = module.ec2_math_service.security_group_id
    }
  }
  security_group_egress_rules = {
    allow_to_all = {
      port             = "0"
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }
  ami           = "ami-05c8486d62efc5d07"
  instance_type = var.nats_service_info.instance_type
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.private_subnet_ids[0]
  user_data     = data.template_cloudinit_config.user_data.rendered
  key_name      = var.nats_service_info.key_name
  tags          = var.tags
}
