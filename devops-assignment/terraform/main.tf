terraform {
  backend "local" {}
}

module "vpc" {
  source = "./modules/vpc"

  project_name          = var.project_name
  environment           = var.environment
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
}

module "eks" {
  source = "./modules/eks"

  project_name            = var.project_name
  environment             = var.environment
  region                  = var.region
  eks_cluster_version     = var.eks_cluster_version
  node_group_desired_size = var.node_group_desired_size
  node_group_min_size     = var.node_group_min_size
  node_group_max_size     = var.node_group_max_size
  node_instance_types     = var.node_instance_types

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
}
