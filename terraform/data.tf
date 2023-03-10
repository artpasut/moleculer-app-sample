data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "template_file" "user_data" {
  template = file("${path.module}/scripts/user_data.sh")
}

data "template_file" "cloud_init" {
  template = file("${path.module}/scripts/cloud-init.yml")
}

data "template_file" "deploy_service" {
  template = file("${path.module}/scripts/deploy-service.sh")
  vars = {
    aws_region         = data.aws_region.current.name
    aws_account_id     = data.aws_caller_identity.current.account_id
    ssm_parameter_name = split("/", aws_ssm_parameter.service.arn)
  }
}

data "template_cloudinit_config" "user_data" {
  gzip          = false
  base64_encode = false

  # Main cloud-config configuration file.
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.cloud_init.rendered
  }

  part {
    filename     = "user_data.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.user_data.rendered
  }
}
