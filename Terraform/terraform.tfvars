# PROVIDERS VALUES 
profile  = "default"
region   = "us-east-1"

# VPC MODULE VALUES
vpc_cidr = "10.0.0.0/16"

# SUBNET  MODULE VALUES
public_subnets = [
    { subnets_cidr      = "10.0.1.0/24"
      availability_zone = "us-east-1a" },
    { subnets_cidr      = "10.0.2.0/24"
      availability_zone = "us-east-1b"}
]

eks_subnets = [
    { subnets_cidr      = "10.0.3.0/24"
      availability_zone = "us-east-1a"},
    { subnets_cidr      = "10.0.4.0/24"
     availability_zone  = "us-east-1b" }
]


db_subnets = [
    { subnets_cidr      = "10.0.5.0/24"
      availability_zone = "us-east-1a"},
    { subnets_cidr      = "10.0.6.0/24"
     availability_zone  = "us-east-1b" }
]


# EKS MODULE VALUES
cluster_name       = "NTI-Cluster"
disk_size          = "20"
instance_types     = ["t2.medium", "t2.large"]
desired_size       = 2
max_size           = 4
min_size           = 2
key_name           = "haitham"

# ECR MODULE VALUES
repository_name    = "nti-project"

# SRV MODULE VALUES
srv_img            = "ami-04b70fa74e45c3917"
srv_type           = "t2.medium"

# DATABASE MODULE VALUES
engine             = "mysql"
engine_version     = "8.0.35"
instance_class     = "db.m5d.large"
dbname             = "djangodb"
dbusername         = "haitham"
dbpassword         = "Haithamelabd"
allocated_storage  = 20 

# BACUKUP MODULE VALUES 
backup_retention_days = 7
backup_schedule = "cron(0 5 ? * SUN-THU *)"