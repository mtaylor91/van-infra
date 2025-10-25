locals {
  name = basename(dirname(get_terragrunt_dir()))
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region = "${local.name}"
}
EOF
}
