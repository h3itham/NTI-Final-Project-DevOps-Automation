# OUTPUT OF EKS SUBNET 1 ID 
output "eks_subnet_1_id" {
    value = aws_subnet.eks_subnets[0].id
}

# OUTPUT OF EKS SUBNET 2 ID 
output "eks_subnet_2_id" {
    value = aws_subnet.eks_subnets[1].id
}

# OUTPUT OF PUBLIC SUBNET 1 ID 
output "public_subnet_1_id" {
    value = aws_subnet.public_subnets[0].id
}

# OUTPUT OF PUBLIC SUBNET 2 ID 
output "public_subnet_2_id" {
    value = aws_subnet.public_subnets[1].id
}

