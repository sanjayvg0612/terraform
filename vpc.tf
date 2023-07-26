#create a vpc 
resource "aws_vpc" "main" {
  cidr_block       = var.cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "main"
  }
}

#create a IGW to VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "IGW"
  }
}

#create a eip 

resource "aws_eip" "nat" {
  vpc   = true
  count = local.nat_count
   tags = {
     Name = "EIP"

   }
}

resource "aws_nat_gateway" "main" {
  allocation_id = element(aws_eip.nat.*.id, count.index)
  count         = local.nat_count
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  tags = {
    name = "NAT"

  }
 
}
