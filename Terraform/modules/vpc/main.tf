# CREATE A VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags       = {
    Name     = "NTI-Project-VPC"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}
# CREATE AN INTERNET GATEWAY
resource "aws_internet_gateway" "igw" {
  vpc_id  = aws_vpc.vpc.id
  tags    = {
    Name  = "NTI-Project-IGW"
  }
}
