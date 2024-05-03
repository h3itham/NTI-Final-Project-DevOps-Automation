# ID OF THE VPC IN WHERE THE SUBNETS WILL BE
variable "vpc_id"{
  type = string
}
# VARIABLE FOR DATABASE 1 ID
variable "db_subnet_1_id" {
  type = string 
}
# VARIABLE FOR DATABASE 2 ID
variable "db_subnet_2_id" {
  type = string 
}
# DATABASE NAME 
variable "dbname" {
  type = string 
}
# DATABASE USERNAME 
variable "dbusername" {
  type = string
}
# DATABASE PASSWORD 
variable "dbpassword" {
  type = string 
}

# DATABASE ENGINE 
variable "engine" {
  type = string
}

# DATABASE ENGINE VERSION 
variable "engine_version" {
  type = string 
}

# DATABASE INSTANCE CLASS 
variable "instance_class" {
  type = string 
}
# ALLOCAATED STORAGE 
variable "allocated_storage" {
  type = number 
}