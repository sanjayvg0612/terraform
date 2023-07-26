locals {
  allow_cidrs_default = merge(var.allow_cidrs_default, { self = aws_vpc.main.cidr_block})
  subnet_list         = [ for cidr_block in cidrsubnets(var.cidr, var.subnet_outer_offsets...) : cidrsubnets(cidr_block, var.subnet_inner_offsets...) ]
}

resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy = "default"

 
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "IGW"
  }
 
}

resource "aws_eip" "nat" {
  vpc   = true
  count = local.nat_count

}

resource "aws_nat_gateway" "main" {
  allocation_id = element(aws_eip.nat.*.id, count.index)
  count         = local.nat_count
  subnet_id     = element(aws_subnet.public.*.id,count.index)

}

resource "aws_default_security_group" "sg" {
  vpc_id                 = aws_vpc.main.id
  revoke_rules_on_delete = true

 

  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      protocol    = "tcp"
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      cidr_blocks = ["0.0.0.0/0"]
      description = ingress.key
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG"

  }
}