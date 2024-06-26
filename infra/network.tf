module "subnet_addrs" {
  source          = "hashicorp/subnets/cidr"
  base_cidr_block = module.vpc.vpc_cidr_block
  networks = [
    {
      name     = "priv-1"
      new_bits = 2
    },
    {
      name     = "priv-2"
      new_bits = 2
    },
    {
      name     = "priv-3"
      new_bits = 2
    },
    {
      name     = "pub-1"
      new_bits = 8
    },
    {
      name     = "pub-2"
      new_bits = 8
    },
    {
      name     = "pub-3"
      new_bits = 8
    },
    {
      name     = "db-1"
      new_bits = 8
    },
    {
      name     = "db-2"
      new_bits = 8
    },
    {
      name     = "db-3"
      new_bits = 8
    }
  ]
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "demo-gjovani"
  cidr = var.vpc-cidr

  azs = data.aws_availability_zones.available.names

  private_subnets = [
    lookup(module.subnet_addrs.network_cidr_blocks, "priv-1"),
    lookup(module.subnet_addrs.network_cidr_blocks, "priv-2"),
    lookup(module.subnet_addrs.network_cidr_blocks, "priv-3")
  ]

  public_subnets = [
    lookup(module.subnet_addrs.network_cidr_blocks, "pub-1"),
    lookup(module.subnet_addrs.network_cidr_blocks, "pub-2"),
    lookup(module.subnet_addrs.network_cidr_blocks, "pub-3")
  ]

  database_subnets = [
    lookup(module.subnet_addrs.network_cidr_blocks, "db-1"),
    lookup(module.subnet_addrs.network_cidr_blocks, "db-2"),
    lookup(module.subnet_addrs.network_cidr_blocks, "db-3"),
  ]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  create_igw             = true

  tags = var.all_tags
}
