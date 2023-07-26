output "id" {
  value = aws_vpc.main.id
}

output "cidr" {
  value = aws_vpc.main.cidr_block
}

output "default_sg" {
  value = aws_default_security_group.sg.id
}

output "default_sg_name" {
  value = aws_default_security_group.sg.name
}

output "nat_eips" {
  value = aws_eip.nat.*.public_ip
}

output "nat_eip_ids" {
  value = aws_eip.nat.*.id
}

output "subnets" {
  value = concat(aws_subnet.public.*.id, aws_subnet.private.*.id)
}

output "public_subnets" {
  value = aws_subnet.public.*.id
}

output "public_subnet_cidrs" {
  value = local.subnet_list[0]
}

output "private_subnets" {
  value = aws_subnet.private.*.id
}

output "private_subnet_cidrs" {
  value = local.subnet_list[1]
}

output "database_subnets" {
  value = aws_subnet.database.*.id
}

output "main_route_table" {
  value = aws_vpc.main.main_route_table_id
}

output "route_tables" {
  value = "${concat(aws_route_table.private.*.id, aws_route_table.database.*.id, tolist([aws_route_table.public.id, aws_vpc.main.main_route_table_id]))}"
}

output "private_route_tables" {
  value = aws_route_table.private.*.id
}

output "public_route_tables" {
  value = tolist([aws_route_table.public.id])
}

output "database_route_tables" {
  value = aws_route_table.database.*.id
}

output "vpc" {
  value = aws_vpc.main
}