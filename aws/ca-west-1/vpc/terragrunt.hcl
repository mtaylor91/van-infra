include "region" {
  path   = find_in_parent_folders("region.hcl")
  expose = true
}

locals {
  region = include.region.locals.name
  name   = "infra-${local.region}"
  cidr   = "10.200.0.0/16"

  azs             = [for i in ["a", "b", "c"]: "${local.region}${i}"]
  private_subnets = [for i in range(3): "10.200.${i}.0/24"]
  public_subnets  = [for i in range(3): "10.200.${i + 10}.0/24"]
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-vpc?ref=v6.4.0"
}

inputs = {
  name    = local.name
  cidr    = local.cidr

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway     = false
  single_nat_gateway     = false
  one_nat_gateway_per_az = false
}
