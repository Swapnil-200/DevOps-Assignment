variable "region" { type = string default = "ap-south-1" }
variable "project_name" { type = string default = "demo-eks" }
variable "environment" { type = string default = "dev" }

variable "vpc_cidr" { type = string default = "10.0.0.0/16" }
variable "private_subnet_cidrs" { type = list(string) default = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"] }
variable "public_subnet_cidrs" { type = list(string) default = ["10.0.101.0/24","10.0.102.0/24","10.0.103.0/24"] }

variable "eks_cluster_version" { type = string default = "1.30" }
variable "node_group_desired_size" { type = number default = 2 }
variable "node_group_min_size" { type = number default = 1 }
variable "node_group_max_size" { type = number default = 3 }
variable "node_instance_types" { type = list(string) default = ["t3.medium"] }
