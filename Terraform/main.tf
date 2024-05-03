# ADDED VPC MODULE FOR NETWORK SETUP
module "vpc" {
  source           = "./modules/vpc"
  vpc_cidr         = var.vpc_cidr
  cluster_name     = var.cluster_name
}

# IMPLEMENTED SUBNET MODULE FOR MANAGING SUBNETS WITHIN VPC
module "subnet" {
  source           = "./modules/subnets"
  vpc_id           = module.vpc.vpc_id
  eks_subnets      = var.eks_subnets
  public_subnets   = var.public_subnets 
  db_subnets       = var.db_subnets
  igw_id           = module.vpc.igw_id
}

# INTEGRATED EKS MODULE FOR KUBERNETES CLUSTER DEPLOYMENT
module "eks" {
  source           = "./modules/eks"
  cluster_name     = var.cluster_name 
  eks_subnet_1_id  = module.subnet.eks_subnet_1_id
  eks_subnet_2_id  = module.subnet.eks_subnet_2_id
  vpc_id           = module.vpc.vpc_id
  key_name         = var.key_name
  disk_size        = var.disk_size
  instance_types   = var.instance_types
  desired_size     = var.desired_size
  max_size         = var.max_size
  min_size         = var.min_size
}

# ADDED DATABASE MODULE FOR DATABASE SETUP WITHIN VPC
module "database" {
  source = "./modules/database"
  vpc_id         = module.vpc.vpc_id
  db_subnet_1_id = module.subnet.db_subnet_1_id
  db_subnet_2_id = module.subnet.db_subnet_2_id
  dbname         = var.dbname 
  dbusername     = var.dbusername 
  dbpassword     = var.dbpassword  
  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class
  allocated_storage = var.allocated_storage
}
# ECR MODULE FOR MANAGING DOCKER REPOSITORIES
module "ecr" {
  source = "./modules/ecr"
  repository_name  = var.repository_name  
}

# SERVERS MODULS JENKINS AND BASTION
module "srv" {
  source = "./modules/srv"
  vpc_id           = module.vpc.vpc_id
  public_subnet_1_id = module.subnet.public_subnet_1_id
  public_subnet_2_id = module.subnet.public_subnet_2_id
  srv_img = var.srv_img
  srv_type = var.srv_type
  key_name = var.key_name
}

# BACKUP MODULE FOR IMPLEMENTING BACKUP SOLUTIONS
module "buckup" {
  source = "./modules/buckup"
   
}



