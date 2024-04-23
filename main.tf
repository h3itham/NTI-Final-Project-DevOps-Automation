module "vpc" {
  source           = "./modules/vpc"
  vpc_cidr         = var.vpc_cidr
}

module "subnet" {
  source           = "./modules/subnets"
  vpc_id           = module.vpc.vpc_id
  eks_subnets      = var.eks_subnets
  public_subnets   = var.public_subnets 
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