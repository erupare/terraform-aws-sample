# VPC
resource "aws_vpc" "sample-vpc_prod" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags {
    Name = "sample-vpc_prod"
  }
}
## Subnet
### WEB
resource "aws_subnet" "public_1" {
    vpc_id                  = "${aws_vpc.sample-vpc_prod.id}"
    cidr_block              = "10.0.0.0/24"
    availability_zone       = "ap-northeast-1a"
    map_public_ip_on_launch = true
    tags {
        Name = "sample_public_1"
    }
}
### RDS
resource "aws_subnet" "private_db1" {
    vpc_id            = "${aws_vpc.sample-vpc_prod.id}"
    cidr_block        = "10.0.1.0/24"
    availability_zone = "ap-northeast-1a"
    tags {
        Name = "private_db1"
    }
}

resource "aws_subnet" "private_db2" {
    vpc_id            = "${aws_vpc.sample-vpc_prod.id}"
    cidr_block        = "10.0.2.0/24"
    availability_zone = "ap-northeast-1c"
    tags {
        Name = "private_db2"
    }
}

## InternetGateway
resource "aws_internet_gateway" "gw_prod" {
    vpc_id = "${aws_vpc.sample-vpc_prod.id}"
    tags {
        Name = "sample_gw"
    }
}
## Routing
resource "aws_route_table" "public_rtb_prod" {
    vpc_id = "${aws_vpc.sample-vpc_prod.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw_prod.id}"
    }
    tags {
        Name = "sample_route"
    }
}
resource "aws_route_table_association" "public_a_prod" {
    subnet_id      = "${aws_subnet.public_1.id}"
    route_table_id = "${aws_route_table.public_rtb_prod.id}"
}
