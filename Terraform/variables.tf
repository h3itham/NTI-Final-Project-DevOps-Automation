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

variable "db_subnets"{
    type              = list(object({
    subnets_cidr      = string
    availability_zone = string
  }))
}


# EKS MODULE VARIABLES 
variable "cluster_name" {}

variable "disk_size" {
 type      = string 
}

variable "instance_types" {
   type    = list(string)
}

variable "desired_size" {
  type     = number   
}

variable "max_size" {
  type     = number
}

variable "min_size" {
  type     = number  
}
variable "key_name" {
  type        = string
}

# ECR MODULES VARAIBLES 
variable "repository_name" {
  type = string
}

# SRV MODULE VARIABLES
variable "srv_img" {
  type = string
}

variable "srv_type" {
  type = string 
}

# DATABASE MODULE VARIABLES  

variable "engine" {
  type = string
}
variable "engine_version" {
  type = string 
}
variable "instance_class" {
  type = string 
}
variable "dbname" {
  type = string
}
variable "dbusername" {
  type = string 
}

variable "dbpassword" {
  type = string 
}
variable "allocated_storage" {
  type = number 
}

# AWS BUCKUP VARIABLES 

variable "backup_schedule" {
  type = string
}

variable "backup_retention_days" {
  type = number 
}