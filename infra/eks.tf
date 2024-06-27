data "aws_ssm_parameter" "office_ip" {
  name = "PG_office_ip"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "eks-cluster-gjovani"
  cluster_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["${data.aws_ssm_parameter.office_ip.value}/32"]
  cluster_endpoint_private_access      = true

  eks_managed_node_groups = {
    node_group_1 = {
      name            = "node-group-1"
      instance_types  = ["t3.small"]
      ami_type        = "BOTTLEROCKET_x86_64"
      capacity_type   = "ON_DEMAND"
      min_size        = 1
      max_size        = 3
      desired_size    = 1
      create_iam_role = true
      iam_role_name   = "EKS-group-gjovani"
      iam_role_additional_policies = {
        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
    }
  }

  access_entries = {
    github = {
      principal_arn = module.iam_iam-assumable-role-with-oidc.iam_role_arn
      policy_associations = {
        github = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy"
          access_scope = {
            namespaces = ["namespace-gjovani"]
            type       = "namespace"
          }
        }
      }
    }
  }

  tags = var.all_tags
}