tags = {
  "Workspace" = "000-terraform-github"
}

name = "test"

alb_info = {
  api_domain_name = "mock.arta.work"
  certificate_arn = "arn:aws:acm:ap-southeast-1:955746675523:certificate/2cbd0199-a75f-42fe-a5f6-ace00965dc1b"
}

vpc_info = {
  availability_zone = ["ap-southeast-1b", "ap-southeast-1c"]
  cidr              = "192.168.0.0/20"
}

api_service_info = {
  health_check_path = "/api/calculator/info"
  instance_type     = "t2.micro"
  key_name          = "application-key"
  name              = "test-api-service"
  service_port      = 3000
  user_data         = "./userdata.sh"
}

calculator_service_info = {
  instance_type = "t2.micro"
  key_name      = "application-key"
  name          = "test-calculator-service"
  user_data     = "./userdata.sh"
}

math_service_info = {
  instance_type = "t2.micro"
  key_name      = "application-key"
  name          = "test-math-service"
  user_data     = "./userdata.sh"
}

nats_service_info = {
  instance_type = "t2.micro"
  key_name      = "application-key"
  name          = "test-nats-service"
  service_port  = 4222
  user_data     = "./userdata.sh"
}
