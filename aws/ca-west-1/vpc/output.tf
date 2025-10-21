output "debian_ami_id" {
  description = "The latest Debian 13 AMI ID from SSM Parameter Store"
  value       = { for k, v in data.aws_ami.debian : k => {
    id           = v.id
    arn          = v.arn
    architecture = v.architecture
    image_id     = v.image_id
  }}
}

output "ssh_key" {
  description = "The SSH key pair"
  value       = aws_key_pair.ssh
}
