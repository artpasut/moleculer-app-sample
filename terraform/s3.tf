resource "aws_s3_bucket" "scripts" {
  bucket = format("%s-scripts-bucket-xhcy", var.name)

  tags = merge(
    var.tags,
    { "Name" = format("%s-scripts-bucket-xhcy", var.name) },
  )
}

resource "aws_s3_bucket_acl" "scripts" {
  bucket = aws_s3_bucket.scripts.id
  acl    = "private"
}

resource "aws_s3_object" "script_service" {
  bucket = aws_s3_bucket.scripts.id
  key    = "scripts/deploy-service.sh"
  source = "./scripts/deploy-service.sh"
  etag   = filemd5("./scripts/deploy-service.sh")
}

resource "aws_s3_object" "script_nats" {
  bucket = aws_s3_bucket.scripts.id
  key    = "scripts/deploy-nats.sh"
  source = "./scripts/deploy-nats.sh"
  etag   = filemd5("./scripts/deploy-nats.sh")
}
