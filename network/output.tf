output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "vpc_cidr" {
  value = "${aws_vpc.vpc.cidr_block}"
}

output "number_of_azs" {
  value = "${length(data.aws_availability_zones.available.names)}"
}

output "nat_eip" {
  value = "${aws_eip.nat_gw.public_ip}"
}

output "public_subnets" {
  value = ["${aws_subnet.subnet_public.*.id}"]
}

output "private_subnets" {
  value = ["${aws_subnet.subnet_private.*.id}"]
}

output "main_route_table" {
  value = "${aws_vpc.vpc.main_route_table_id}"
}

output "private_route_table" {
  value = "${aws_route_table.private.id}"
}
