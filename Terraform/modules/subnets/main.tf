# CREATE EKS SUBNETS
resource "aws_subnet" "eks_subnets" {
  count             = length(var.eks_subnets)
  vpc_id            = var.vpc_id
  cidr_block        = var.eks_subnets[count.index].subnets_cidr
  availability_zone = var.eks_subnets[count.index].availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "eks_subnet_${count.index}"
  }
}

# CREATE PUBLIC ROUTE TABLE 
resource "aws_route_table" "public-rt" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }
}

# ASSIGN THE PUBLIC ROUTE TABLE TO ALL EKS SUBNETS
resource "aws_route_table_association" "eks-rta" {
  count          = length(aws_subnet.eks_subnets)
  subnet_id      = aws_subnet.eks_subnets[count.index].id
  route_table_id = aws_route_table.public-rt.id
}

# CREATE PUBLIC SUBNETS
resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnets)
  vpc_id            = var.vpc_id
  cidr_block        = var.public_subnets[count.index].subnets_cidr
  availability_zone = var.public_subnets[count.index].availability_zone
  tags = {
    Name = "public_subnet_${count.index}"
  }
}

# ASSIGN THE PUBLIC ROUTE TABLE TO ALL PUBLIC SUBNETS
resource "aws_route_table_association" "public-rta" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public-rt.id
}

# CREATE DB SUBNETS
resource "aws_subnet" "db_subnets" {
  count             = length(var.db_subnets)
  vpc_id            = var.vpc_id
  cidr_block        = var.db_subnets[count.index].subnets_cidr
  availability_zone = var.db_subnets[count.index].availability_zone
  tags = {
    Name = "db_subnet_${count.index}"
  }
}

# CREATE PRIVATE ROUTE TABLE 
resource "aws_route_table" "private-rt" {
  vpc_id = var.vpc_id
}

# ASSIGN THE PRIVATE ROUTE TABLE TO ALL DB SUBNETS
resource "aws_route_table_association" "db-rta" {
  count          = length(aws_subnet.db_subnets)
  subnet_id      = aws_subnet.db_subnets[count.index].id   
  route_table_id = aws_route_table.private-rt.id
}

