# Find RHEL 9 images.
data "aws_ami" "rhel9" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-9*"]
  }

  owners = ["309956199498"]
}

# Lookup the domain.
data "aws_route53_zone" "default" {
  name = var.domain
}
