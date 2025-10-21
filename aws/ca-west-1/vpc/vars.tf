variable "key_name" {
  description = "The name of the key pair to use for the EC2 instance"
  default     = null
  type        = string
}

variable "public_key" {
  description = "The public key material to use for the key pair"
  default     = null
  type        = string
}
