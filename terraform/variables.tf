# The AWS domain to use.
variable "domain" {
  description = "The domain to use for the DNS records."
  type        = string
  default     = "adfinis.dev"
}

# The amount of servers to create.
variable "server_count" {
  description = "The amount of servers to create."
  type        = number
  default     = 2
}
