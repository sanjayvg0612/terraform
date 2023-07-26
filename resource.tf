resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(local.subnet_list[0])
  cidr_block              = local.subnet_list[0][count.index]
  availability_zone       = element(data.aws_availability_zones.available.names, count.index + var.skip_az)
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet{$count.index}"

  }

}
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(local.subnet_list[1])
  cidr_block              = local.subnet_list[1][count.index]
  availability_zone       = element(data.aws_availability_zones.available.names, count.index + var.skip_az)
  map_public_ip_on_launch = false

  tags = {
    Name = "private_subnet{$count.index}"

  }
}



resource "aws_subnet" "database" {
  vpc_id                  = aws_vpc.main.id
  count                   = var.separate_db_subnets ? length(local.subnet_list[1]) : 0
  cidr_block              = local.subnet_list[2][count.index]
  availability_zone       = element(data.aws_availability_zones.available.names, count.index + var.skip_az)
  map_public_ip_on_launch = false

  tags = {
    Name = "database_subnet{$count.index}"

  }
}

resource "aws_default_security_group" "main" {
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

