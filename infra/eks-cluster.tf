module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.6.1"

  name = "myapp-eks-cluster"
  kubernetes_version = "1.27"
  endpoint_public_access = true
  
  # Configure the VPC and Subnets -->
  subnet_ids = module.myapp-vpc.private_subnets
  vpc_id = module.myapp-vpc.vpc_id
  
  # Configure Node Groups (worker nodes)
  eks_managed_node_groups = {
    dev = {
        min_size = 1
        max_size = 3
        desired_size = 3

        instance_types = ["t3.micro"]
    }
  }
  # The tags are optional -->
  tags = {
    environment = "development"
    application = "myapp"
  }
}