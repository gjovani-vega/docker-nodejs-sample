module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "nodejs-demo-gjovani"

  repository_read_write_access_arns = [module.iam_iam-assumable-role-with-oidc.iam_role_arn]
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 10 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 10
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = var.all_tags
}