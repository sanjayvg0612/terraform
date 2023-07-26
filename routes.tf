resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  count  = length(local.subnet_list[1])

  tags = {
    Name        = "private {$count.index}"
    Environment = var.environment
  }
}

resource "aws_route" "private" {
  count                  = length(local.subnet_list[1])
  route_table_id         = element(aws_route_table.private.*.id,count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[0].id 
}




resource "aws_route" "private_tgw" {
  count                  = var.transit_gateway_attach ? length(local.private_route_tables_tgw_set) : 0
  route_table_id         = local.private_route_tables_tgw_set[count.index][0]
  destination_cidr_block = local.private_route_tables_tgw_set[count.index][1]
  transit_gateway_id     = var.transit_gateway_id
}

resource "aws_route_table_association" "private" {
  count          = length(local.subnet_list[1])
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id,count.index)

  

}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  count  = length(local.subnet_list[0])
  

 tags = {
    Name        = "public {$count.index}"
    Environment = var.environment
  }
}

resource "aws_route" "public" {
  count                  = length(local.subnet_list[0])
  route_table_id         =  element(aws_route_table.public.*.id,count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id

  
}


resource "aws_route" "public_tgw" {
  count                  = var.transit_gateway_attach ? length(var.transit_gateway_routes) : 0
  route_table_id         =  element(aws_route_table.public.*.id,count.index)
  destination_cidr_block = var.transit_gateway_routes[count.index][1]
  transit_gateway_id     = var.transit_gateway_id
}

resource "aws_route_table_association" "public" {
  count          = length(local.subnet_list[0])
  subnet_id      = element(aws_subnet.public.*.id,count.index)
  route_table_id =  element(aws_route_table.public.*.id,count.index)

  
}


resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id
  count  = var.separate_db_subnets ? length(local.subnet_list[2]) : 0

  tags = {
    Name        = "database {$count.index}"
    Environment = var.environment
  }
}

resource "aws_route" "database" {
  count                  = var.separate_db_subnets ? length(local.subnet_list[2]) : 0
  route_table_id         = element(aws_route_table.database.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.main.*.id, count.index)
  
}

locals {
  database_route_tables_tgw_set = setproduct(aws_route_table.public[*].id, var.transit_gateway_routes)
} 

resource "aws_route" "database_tgw" {
  count                  = var.transit_gateway_attach ? length(local.database_route_tables_tgw_set) : 0
  route_table_id         = local.database_route_tables_tgw_set[count.index][0]
  destination_cidr_block = local.database_route_tables_tgw_set[count.index][1]
  transit_gateway_id     = var.transit_gateway_id
}

resource "aws_route_table_association" "database" {
  count          = var.separate_db_subnets ? length(local.subnet_list[2]) : 0
  subnet_id      = element(aws_subnet.database.*.id, count.index)
  route_table_id = element(aws_route_table.database.*.id,count.index)
  
}