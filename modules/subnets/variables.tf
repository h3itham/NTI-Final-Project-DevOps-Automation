# ID of the vpc in where the subnets will be
variable "vpc_id"{
    type        = string
}

# EKS sUBNETES INFO
variable "eks_subnets"{
  type        = list(object({
    subnets_cidr      = string
    availability_zone = string
  }))
}

# PUBLIC SUBNETS INFO
variable "public_subnets"{
  type = list(object({
    subnets_cidr = string
    availability_zone = string
  }))
}

# INTERNET GATEWAY ID 
variable "igw_id"{
    type = string
}
