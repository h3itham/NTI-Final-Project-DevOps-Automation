# OUTPU TO RETRIVE ALL WEB SUBNETS ID
output "eks_subnets_id" {
    value = aws_subnet.eks_subnets[*].id
}
# OUTPUT OF APP SUBNET 1 ID 
output "eks_subnet_1_id" {
    value = aws_subnet.eks_subnets[0].id
}
# OUTPUT OF APP SUBNET 2 ID 
output "eks_subnet_2_id" {
    value = aws_subnet.eks_subnets[1].id
}
