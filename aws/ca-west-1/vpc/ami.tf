locals {
  architectures = {
    x86_64 = "x86_64"
    arm64  = "arm64"
  }
}

data "aws_ssm_parameters_by_path" "debian_ami" {
  path      = "/aws/service/debian/release/13/latest"
  recursive = true
}

data "aws_ami" "debian" {
  for_each = local.architectures

  most_recent = true

  filter {
    name   = "architecture"
    values = [each.key]
  }

  filter {
    name   = "image-id"
    values = data.aws_ssm_parameters_by_path.debian_ami.values
  }
}
