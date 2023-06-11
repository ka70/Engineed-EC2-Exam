# ---------------------------
# VPC
# ---------------------------
resource "aws_vpc" "main"{
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true   # DNSホスト名を有効化
  tags = {
    Name = "mainVPC"
  }
}

# ---------------------------
# Subnet
# ---------------------------
resource "aws_subnet" "public_subnet_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
}

# ---------------------------
# Internet Gateway
# ---------------------------
resource "aws_internet_gateway" "main_igw" {
  vpc_id            = aws_vpc.main.id
}

# ---------------------------
# Route table
# ---------------------------
resource "aws_route_table" "public_rtb" {
  vpc_id            = aws_vpc.main.id
  route {
    cidr_block      = "0.0.0.0/0"
    gateway_id      = aws_internet_gateway.main_igw.id
  }
}

# SubnetとRoute tableの関連付け
resource "aws_route_table_association" "public_rtb_association" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.public_rtb.id
}

# ---------------------------
# Security Group
# ---------------------------
# 自分のパブリックIP取得
data "http" "ifconfig" {
  url = "http://ipv4.icanhazip.com/"
}

variable "allowed_cidr" {
  default = null
}

locals {
  myip          = chomp(data.http.ifconfig.body)
  allowed_cidr  = (var.allowed_cidr == null) ? "${local.myip}/32" : var.allowed_cidr
}

# Security Group作成
resource "aws_security_group" "web_ec2_sg" {
  name              = "web-ec2-sg"
  description       = "For WEB EC2"
  vpc_id            = aws_vpc.main.id
  # インバウンドルール
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.allowed_cidr]
  }
  # アウトバウンドルール
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
