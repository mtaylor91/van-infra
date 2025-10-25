locals {
  region        = include.region.locals.name
  name          = "infra-${local.region}-gateway"
  instance_type = "t3.micro"
}

include "provider" {
  path   = find_in_parent_folders("provider.tf")
}

include "region" {
  path   = find_in_parent_folders("region.hcl")
  expose = true
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-ec2-instance?ref=v6.1.2"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  name                        = local.name
  ami                         = dependency.vpc.outputs.debian_ami_id["x86_64"].id
  key_name                    = dependency.vpc.outputs.ssh_key.key_name
  associate_public_ip_address = true
  instance_type               = local.instance_type
  create_security_group       = true
  source_dest_check           = false
  user_data                   = templatefile("user-data.txt", {
    hostname                  = local.name
    TAILSCALE_AUTH_KEY        = get_env("TAILSCALE_AUTH_KEY")
  })

  security_group_ingress_rules = {
    allow_ingress_ipv4_ssh = {
      cidr_ipv4   = "0.0.0.0/0"
      description = "Allow SSH from any IPv4"
      from_port   = 22
      ip_protocol = "tcp"
    }
    allow_ingress_ipv6_ssh = {
      cidr_ipv6   = "::/0"
      description = "Allow SSH from any IPv6"
      from_port   = 22
      ip_protocol = "tcp"
    }
  }

  security_group_egress_rules = {
    allow_egress_ipv4_all = {
      cidr_ipv4   = "0.0.0.0/0"
      from_port   = 0
      to_port     = 0
      ip_protocol = "-1"
      description = "Allow all outbound IPv4 traffic"
    }
    allow_egress_ipv6_all = {
      cidr_ipv6   = "::/0"
      from_port   = 0
      to_port     = 0
      ip_protocol = "-1"
      description = "Allow all outbound IPv6 traffic"
    }
  }

  subnet_id = dependency.vpc.outputs.public_subnets[0]

  vpc_security_group_ids = [
    dependency.vpc.outputs.default_security_group_id,
  ]
}
