resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(local.subnet_list[1])
  cidr_block              = local.subnet_list[1][count.index]
  availability_zone       = element(data.aws_availability_zones.available.names, count.index + var.skip_az)
  map_public_ip_on_launch = false

  tags = {
      Name        = "private.${var.name}"
      Environment = var.environment
    }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  count  = length(local.subnet_list[1])

  tags = {
    Name        = "private.${var.name}"
    Environment = var.environment
  }
}

resource "aws_route" "private" {
  count                  = length(local.subnet_list[1])
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.main.*.id, count.index)
}

locals {
  private_route_tables_tgw_set = setproduct(aws_route_table.private[*].id, var.transit_gateway_routes)
}

resource "aws_route" "private_tgw" {
  count                  = var.transit_gateway_attach ? length(local.private_route_tables_tgw_set) : 0
  route_table_id         = local.private_route_tables_tgw_set[count.index]
  destination_cidr_block = local.private_route_tables_tgw_set[count.index][1]
  transit_gateway_id     = var.transit_gateway_id
}

resource "aws_route_table_association" "private" {
  count          = length(local.subnet_list[1])
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}