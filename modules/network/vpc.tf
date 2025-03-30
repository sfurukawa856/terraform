data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs         = slice(data.aws_availability_zones.available.names, 0, var.az_count)
  az_suffixes = [for az in local.azs : substr(az, length(az) - 2, 2)]
}

# VPC作成
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name    = "${var.project_name}-${var.env}-vpc"
    Project = var.project_name
    Env     = var.env
  }
}

# インターネットゲートウェイ作成
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name    = "${var.project_name}-${var.env}-igw"
    Project = var.project_name
    Env     = var.env
  }
}

# サブネット作成
resource "aws_subnet" "public" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = local.azs[count.index % length(local.azs)]
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project_name}-${var.env}-public-${local.az_suffixes[count.index % length(local.azs)]}"
    Project = var.project_name
    Env     = var.env
  }
}

resource "aws_subnet" "private" {
  count             = var.private_subnet_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + var.public_subnet_count)
  availability_zone = local.azs[count.index % length(local.azs)]

  tags = {
    Name    = "${var.project_name}-${var.env}-private-${local.az_suffixes[count.index % length(local.azs)]}"
    Project = var.project_name
    Env     = var.env
  }
}

# ルートテーブル作成
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name    = "${var.project_name}-${var.env}-public-rt"
    Project = var.project_name
    Env     = var.env
  }
}

resource "aws_route_table" "private" {
  count  = var.private_subnet_count
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "${var.project_name}-${var.env}-private-rt-${count.index}"
    Project = var.project_name
    Env     = var.env
  }
}

# ルートテーブルとサブネットの関連付け
resource "aws_route_table_association" "public" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = var.private_subnet_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# ルートテーブルにインターネットゲートウェイを関連付け
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
