resource "aws_ssm_parameter" "service" {
  name  = format("/%s/services", var.name)
  type  = "String"
  value = format("NAMESPACE=\nLOGGER=true\nLOGLEVEL=info\nSERVICEDIR=services\nTRANSPORTER=nats://%s:4222", module.ec2_nats_service.private_dns)
}
