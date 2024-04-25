module "vpc" {
  source           = "./modules/vpc"
  vpc_cidr         = var.vpc_cidr
  cluster_name     = var.cluster_name
}

module "subnet" {
  source           = "./modules/subnets"
  vpc_id           = module.vpc.vpc_id
  eks_subnets      = var.eks_subnets
  public_subnets   = var.public_subnets 
  db_subnets       = var.db_subnets
  igw_id           = module.vpc.igw_id
}

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

module "ecr" {
  source = "./modules/ecr"
  repository_name  = var.repository_name  
}

module "srv" {
  source = "./modules/srv"
  vpc_id           = module.vpc.vpc_id
  public_subnet_1_id = module.subnet.public_subnet_1_id
  public_subnet_2_id = module.subnet.public_subnet_2_id
  srv_img = var.srv_img
  srv_type = var.srv_type
  key_name = var.key_name
}