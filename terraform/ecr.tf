resource "aws_ecr_repository" "services" {
  name = format("%s-service-ecr", var.name)

  image_scanning_configuration {
    scan_on_push = true
  }
}
