# Create a TLS private key.
resource "tls_private_key" "default" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Store the private key in a file.
resource "local_file" "private_key" {
  content         = tls_private_key.default.private_key_pem
  filename        = pathexpand("~/.ssh/config.d/id_rsa-rhcsa-lab")
  file_permission = 0600
}

# Upload the public key to AWS.
resource "aws_key_pair" "default" {
  key_name   = "rhcsa-lab"
  public_key = tls_private_key.default.public_key_openssh
}

# Create a VPC.
resource "aws_vpc" "default" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "rhcsa-lab"
  }
}

# Create a subnet.
resource "aws_subnet" "default" {
  vpc_id     = aws_vpc.default.id
  cidr_block = "192.168.1.0/24"
  tags = {
    Name = "rhcsa-lab"
  }
}

# Create a route table to allow internet access.
resource "aws_route_table" "default" {
  vpc_id = aws_vpc.default.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }
  tags = {
    Name = "rhcsa-lab"
  }
}

# Associate the route table with the subnet.
resource "aws_route_table_association" "default" {
  subnet_id      = aws_subnet.default.id
  route_table_id = aws_route_table.default.id
}

# Create a security group for the workstation.
resource "aws_security_group" "workstation" {
  vpc_id = aws_vpc.default.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a security group for the servers.
resource "aws_security_group" "servers" {
  vpc_id = aws_vpc.default.id
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.workstation.id]
  }
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.workstation.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an internet gateway.
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
}

# Create a workstation instance.
resource "aws_instance" "workstation" {
  ami                         = data.aws_ami.rhel9.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.default.id
  key_name                    = aws_key_pair.default.key_name
  vpc_security_group_ids      = [aws_security_group.workstation.id]
  associate_public_ip_address = true
  tags = {
    Name = "workstation.${var.domain}"
  }
}

# Create a volume for the workstation instance.
resource "aws_ebs_volume" "workstation" {
  availability_zone = aws_instance.workstation.availability_zone
  size              = 16
}

# Attach the volume to the workstation instance.
resource "aws_volume_attachment" "workstation" {
  device_name = "/dev/xvdf"
  instance_id = aws_instance.workstation.id
  volume_id   = aws_ebs_volume.workstation.id
}

# Create server instances.
resource "aws_instance" "server" {
  count                  = var.server_count
  ami                    = data.aws_ami.rhel9.id
  instance_type          = "t2.small"
  subnet_id              = aws_subnet.default.id
  key_name               = aws_key_pair.default.key_name
  vpc_security_group_ids = [aws_security_group.servers.id]
  associate_public_ip_address = true
  tags = {
    Name = "server-${count.index}.${var.domain}"
  }
}

# Create a volume for the server instances.
resource "aws_ebs_volume" "server" {
  count             = length(aws_instance.server.*)
  availability_zone = aws_instance.server[count.index].availability_zone
  size              = 16
}

# Attach the volume to the server instances.
resource "aws_volume_attachment" "server" {
  count       = length(aws_instance.server.*)
  device_name = "/dev/xvdf"
  instance_id = aws_instance.server[count.index].id
  volume_id   = aws_ebs_volume.server[count.index].id
}

# Set the DNS record for workstation instance.
resource "aws_route53_record" "workstation" {
  zone_id = data.aws_route53_zone.default.zone_id
  name    = "workstation"
  type    = "A"
  records = [aws_instance.workstation.public_ip]
  ttl     = 300
}

# Set DNS record for the server instances, pointing to the private IP.
resource "aws_route53_record" "server" {
  count   = length(aws_instance.server.*)
  zone_id = data.aws_route53_zone.default.zone_id
  name    = "server-${count.index}"
  type    = "A"
  # records = [element(aws_instance.server.*.private_ip, count.index)]
  records = [aws_instance.server[count.index].private_ip]
  ttl     = 300
}

# Create the SSH configuration file.
resource "local_file" "ssh_config" {
  content = templatefile("${path.module}/templates/ssh_config.tpl", {
    workstation  = aws_route53_record.workstation.fqdn
    servers      = aws_route53_record.server[*].fqdn
    ssh_key_path = local_file.private_key.filename
    ssh_user     = "ec2-user"
  })
  filename = pathexpand("~/.ssh/config.d/rhcsa-lab.conf")
}
