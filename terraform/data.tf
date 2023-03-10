data "template_file" "user_data" {
  template = file("./scripts/user_data.sh")
}

data "template_file" "cloud_init" {
  template = file("./scripts/cloud-init.yml")
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
