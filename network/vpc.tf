resource "aws_vpc" "vpc" {
    cidr_block = "${var.vpc_cidr}"
    tags {
        Name = "${var.vpc_tag}"
    }
}

resource "aws_subnet" "subnet_public" {
    vpc_id = "${aws_vpc.vpc.id}"
    availability_zone = "${element(split(",", lookup(var.regions, "${var.region}")), count.index)}"
    cidr_block = "${cidrsubnet(var.vpc_cidr, 4, count.index)}"
    count = "${length(split(",", lookup(var.regions, "${var.region}")))}"
    map_public_ip_on_launch = true
    tags {
        Name = "${var.vpc_tag} Public"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.vpc.id}"
    tags {
        Name = "${var.vpc_tag}"
    }
}

resource "aws_route" "public_route" {
    route_table_id         = "${aws_vpc.vpc.main_route_table_id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = "${aws_internet_gateway.igw.id}"
}

resource "aws_subnet" "subnet_private" {
    vpc_id = "${aws_vpc.vpc.id}"
    availability_zone = "${element(split(",", lookup(var.regions, "${var.region}")), count.index)}"
    cidr_block = "${cidrsubnet(var.vpc_cidr, 4, "${count.index + length(split(",", lookup(var.regions, "${var.region}")))}")}"
    count = "${length(split(",", lookup(var.regions, "${var.region}")))}"
    map_public_ip_on_launch = false
    tags {
        Name = "${var.vpc_tag} Private"
    }
}

resource "aws_eip" "nat_gw" {
  vpc      = true
}

resource "aws_nat_gateway" "nat_gw" {
    allocation_id = "${aws_eip.nat_gw.id}"
    subnet_id = "${aws_subnet.subnet_public.0.id}"
}

resource "aws_route_table" "private" {
    vpc_id = "${aws_vpc.vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.nat_gw.id}"
    }

    tags {
        Name = "${var.vpc_tag} Private"
    }
}

resource "aws_route_table_association" "private" {
    count = "${length(split(",", lookup(var.regions, "${var.region}")))}"
    subnet_id = "${element(aws_subnet.subnet_private.*.id, count.index)}"
    route_table_id = "${aws_route_table.private.id}"
}

resource "null_resource" "tag_main_rt" {
  provisioner "local-exec" {
    command = "aws ec2 create-tags --resources ${aws_vpc.vpc.main_route_table_id} --tags Key=Name,Value=\"${var.vpc_tag} Public\" --profile ${var.profile} --region ${var.region}"
  }
}
