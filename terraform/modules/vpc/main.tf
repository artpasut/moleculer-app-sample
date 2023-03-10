locals {
  az_shorten = [for az in var.availability_zone : element(split("-", az), 2)]
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.tags,
    { "Name" = format("%s-vpc", var.name) }
  )
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    { "Name" = format("%s-internet-gateway", var.name) }
  )
}

resource "aws_subnet" "public" {
  count                   = length(var.availability_zone)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 2, count.index)
  availability_zone       = element(var.availability_zone, count.index)
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    { "Name" = format("%s-public-%s-subnet", var.name, element(local.az_shorten, count.index)) }
  )
}

resource "aws_subnet" "private" {
  count                   = length(var.availability_zone)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 2, count.index + 2)
  availability_zone       = element(var.availability_zone, count.index)
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    { "Name" = format("%s-private-%s-subnet", var.name, element(local.az_shorten, count.index)) }
  )
}

resource "aws_eip" "nat" {
  vpc = true

  tags = merge(
    var.tags,
    { "Name" = format("%s-eip-nat", var.name) }
  )
}

resource "aws_nat_gateway" "this" {
  depends_on = [aws_internet_gateway.this]

  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.tags,
    { "Name" = format("%s-nat", var.name) }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    { "Name" = format("%s-public-rtb", var.name) }
  )
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.availability_zone)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    { "Name" = format("%s-private-rtb", var.name) }
  )
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.availability_zone)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
