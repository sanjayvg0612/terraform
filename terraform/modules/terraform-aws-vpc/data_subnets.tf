resource "aws_subnet" "database" {
  vpc_id                  = aws_vpc.main.id
  count                   = var.separate_db_subnets ? length(local.subnet_list[2]) : 0
  cidr_block              = local.subnet_list[2][count.index]
  availability_zone       = element(data.aws_availability_zones.available.names, count.index + var.skip_az)
  map_public_ip_on_launch = false

  tags = {
    Name        = "private.database.${var.name}"
    Environment = var.environment
  }
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id
  count  = var.separate_db_subnets ? length(local.subnet_list[2]) : 0

  tags = {
    Name        = "private.database.${var.name}"
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
  route_table_id = element(aws_route_table.database.*.id, count.index)
}