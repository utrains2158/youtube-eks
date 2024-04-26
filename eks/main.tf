#VPC creation
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "EKS_cluster_vpc"
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.azs.names
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true

  tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
  }
  public_subnet_tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
    "kubernetes.io/role/elb"               = 1

  }
  private_subnet_tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
    "kubernetes.io/role/private_elb"       = 1

  }
}


#EKS

module "eks" {
  source                         = "terraform-aws-modules/eks/aws"
  cluster_name                   = "my-eks-cluster"
  cluster_version                = "1.29"
  cluster_endpoint_public_access = true
  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets

  eks_managed_node_groups = {
    nodes = {
      min_size       = 1
      max_size       = 3
      desired_size   = 2
      instance_types = var.instance_types
    }
  }
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

# #SG
# module "sg" {
#   source = "terraform-aws-modules/security-group/aws"

#   name        = "DevOpsMaster_sg"
#   description = "Security group for jenkins server"
#   vpc_id      = module.vpc.vpc_id


#   ingress_with_cidr_blocks = [
#     {
#       from_port   = 8080
#       to_port     = 8080
#       protocol    = "tcp"
#       description = "HTTP"
#       cidr_blocks = "0.0.0.0/0"
#     },
#     {
#       from_port   = 22
#       to_port     = 22
#       protocol    = "tcp"
#       description = "SSH"
#       cidr_blocks = "0.0.0.0/0"
#     }
#   ]
#   egress_with_cidr_blocks = [
#     {
#       from_port   = 0
#       to_port     = 0
#       protocol    = "-1"
#       cidr_blocks = "0.0.0.0/0"
#     }
#   ]
#   tags = {
#     Name = "DevOpsMaster_sg"
#   }
# }

# #ec2

# module "ec2_instance" {
#   source = "terraform-aws-modules/ec2-instance/aws"

#   name = "jenkins_server"

#   instance_type               = var.instance_type
#   ami                         = data.aws_ami.example.id
#   key_name                    = "my-new-key"
#   monitoring                  = true
#   vpc_security_group_ids      = [module.sg.security_group_id]
#   subnet_id                   = module.vpc.public_subnets[0]
#   associate_public_ip_address = true
#   availability_zone           = data.aws_availability_zones.azs.names[0]
#   user_data                   = file("jenkins-install.sh")


#   tags = {
#     Name        = "jankins_server"
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }