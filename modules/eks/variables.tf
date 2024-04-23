# ID OF THE VPC IN WHERE THE SUBNETS WILL BE
variable "vpc_id"{
  type = string
}

# CLUSTER NAME 
variable "cluster_name" {
    type = string
}

# VARIABLE FOR EKS SUBNET 1 
variable "eks_subnet_1_id" {
  type = string  
}

# VARIABLE FOR EKS SUBNET 2 
variable "eks_subnet_2_id" {
  type = string 
}

# NODE GROUP DISK SIZE 
variable "disk_size" {
  type    = string
  
}

# NODE GROUP INSTANCE SIZE 
variable "instance_types" {
  type    = list(string)
}

# NODE GROUP DESIRED SIZE 
variable "desired_size" {
  type = number
}

# NODE GROUP MAX SIZE 
variable "max_size" {
  type = number
}

# NODE GROUP MIN SIZE 
variable "min_size" {
  type = number
}

# SSH KEY NAME 
variable "key_name" {
    type = string  
}