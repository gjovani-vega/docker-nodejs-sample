module "iam_github_oidc_provider" {
  source         = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider"
  client_id_list = ["sts.amazonaws.com"]
  tags           = var.default_omega
}

module "iam_iam-assumable-role-with-oidc" {
  source                         = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  create_role                    = true
  role_name                      = "github-actions-gjovani"
  provider_url                   = module.iam_github_oidc_provider.url
  oidc_subjects_with_wildcards   = [var.repo_github]
  role_policy_arns               = [module.iam_policy.arn]
  oidc_fully_qualified_audiences = ["sts.amazonaws.com"]
  number_of_role_policy_arns     = 1
  tags                           = var.all_tags
}

module "iam_policy" {
  source        = "terraform-aws-modules/iam/aws//modules/iam-policy"
  name          = "github-actions-policy-gjovani"
  create_policy = true
  path          = "/"
  description   = "Policy for GitHub Actions - gjovani"
  policy        = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchGetImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ],
        "Resource": "${module.ecr.repository_arn}"
      },
      {
        "Effect": "Allow",
        "Action": [
          "eks:ListClusters",
          "eks:ListNodegroups",
          "eks:DescribeCluster",
          "eks:DescribeNodegroup"
        ],
        "Resource": "${module.eks.cluster_arn}"
      }
    ]
  }
  EOF
  tags          = var.all_tags
}

module "vpc_cni_irsa_role" {
  source                = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name             = "irsa-role-gjovani"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true
  oidc_providers = {
    main = {
      provider_arn               = module.iam_github_oidc_provider.arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }

  tags = var.all_tags
}