# THE AMI ID FOR THE INSTANCES
variable "srv_img" {
  type        = string
}
# THE INSTANCE TYPE FOR THE INSTANCES
variable "srv_type" {
  type        = string
}

# THE NAME OF THE EC2 KEY PAIR TO ASSOCIATE WITH THE INSTANCES
variable "key_name" {
  type        = string
}


# PUBLIC SUBNET 1 ID 
variable "public_subnet_1_id" {
  type = string
}

# PUBLIC SUBNET 2 ID 
variable "public_subnet_2_id" {
  type = string
}