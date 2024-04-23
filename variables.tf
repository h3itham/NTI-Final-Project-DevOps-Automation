# PROVIDERS VARIABLES 
variable "profile" {}
variable "region" {}

# VPC MODULE  VARIABLES
variable "vpc_cidr"{}

# SUBNET MODULE VARIABLES

variable "eks_subnets"{
    type              = list(object({
    subnets_cidr      = string
    availability_zone = string
  }))
}

variable "public_subnets"{
    type              = list(object({
    subnets_cidr      = string
    availability_zone = string
  }))
}

# CLUSTER NAME 
variable "cluster_name" {}

# DISK SIZE FOR GROUP NODE INSTANCE 
variable "disk_size" {
 type      = string 
}

# INSTANCE TYPES OF GOUP NODE 
variable "instance_types" {
   type    = list(string)
}
# DESIRED NODE GROUP NUMBER 
variable "desired_size" {
  type     = number   
}

# MAX NODE GROUP NUMBER 
variable "max_size" {
  type     = number
}
# MIN NODE GROUP NUMBER 

variable "min_size" {
  type     = number  
}

# NAME OF THE SSH KEY PAIR USED TO ACCESS THE INSTANCES
variable "key_name" {
  type        = string
}

