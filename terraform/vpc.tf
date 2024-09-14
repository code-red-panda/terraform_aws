locals {
  az_a = data.aws_availability_zones.this.names[0]
}

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc_us_east_2"
  }
}

resource "aws_subnet" "a_public" {
  availability_zone = local.az_a
  cidr_block        = "10.0.0.0/24"
  vpc_id            = aws_vpc.this.id

  tags = {
    Name   = "subnet_us_east_2a_public"
    Public = "true"
  }
}

resource "aws_subnet" "a_private" {
  availability_zone = local.az_a
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.this.id

  tags = {
    Name   = "subnet_us_east_2a_private"
    Public = "false"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name   = "igw_us_east_2"
    Public = "true"
  }
}

resource "aws_eip" "a_public" {
  tags = {
    Name   = "eip_us_east_2a"
    Public = "true"
  }

  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "a_public" {
  allocation_id = aws_eip.a_public.id
  subnet_id     = aws_subnet.a_public.id

  tags = {
    Name   = "ngw_us_east_2a"
    Public = "true"
  }

  depends_on = [aws_internet_gateway.this, aws_eip.a_public]
}

resource "aws_route_table" "internet" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name   = "route_table_us_east_2_internet"
    Public = "true"
  }
}

resource "aws_route_table" "a_private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.a_public.id
  }

  tags = {
    Name   = "route_table_us_east_2a_private"
    Public = "false"
  }
}

resource "aws_route_table_association" "a_public" {
  subnet_id      = aws_subnet.a_public.id
  route_table_id = aws_route_table.internet.id
}

resource "aws_route_table_association" "a_private" {
  subnet_id      = aws_subnet.a_private.id
  route_table_id = aws_route_table.a_private.id
}
