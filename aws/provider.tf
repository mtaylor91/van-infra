generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "s3" {
    bucket         = "mtaylor91-van-infra-terraform-state"
    key            = "${path_relative_to_include()}/tofu.tfstate"
    region         = "ca-west-1"
    encrypt        = true
    dynamodb_table = "mtaylor91-van-infra-terraform-locking"
  }
}
EOF
}
