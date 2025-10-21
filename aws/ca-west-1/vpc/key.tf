locals {
  key_name   = var.key_name != null ? var.key_name : "${var.name}-key"
  public_key = var.public_key != null ? var.public_key : file("~/.ssh/id_ed25519.pub")
}

resource "aws_key_pair" "ssh" {
  key_name   = local.key_name
  public_key = local.public_key
}
