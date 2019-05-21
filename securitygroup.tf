# Security Group
resource "aws_security_group" "prod" {
    name        = "dev-web"
    description = "It is a security group on http"
    vpc_id      = "${aws_vpc.sample-vpc_prod.id}"
    tags {
        Name = "dev_web"
    }
}
## WEB
resource "aws_security_group_rule" "ssh-wireless_prod" {
    type              = "ingress"
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = ["xxx.xxx.xxx.xxx/32"]
    security_group_id = "${aws_security_group.prod.id}"
}
resource "aws_security_group_rule" "ssh-wired_prod" {
    type              = "ingress"
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = ["xxx.xxx.xxx.xxx/32"]
    security_group_id = "${aws_security_group.prod.id}"
}
resource "aws_security_group_rule" "from_XXX_prod" {
    type              = "ingress"
    from_port         = 2201
    to_port           = 2201
    protocol          = "tcp"
    cidr_blocks       = ["xxx.xxx.xxx.xxx/32"]
    security_group_id = "${aws_security_group.prod.id}"
}
resource "aws_security_group_rule" "ssh-from-XXX_prod" {
    type              = "ingress"
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = ["xxx.xxx.xxx.xxx/32"]
    security_group_id = "${aws_security_group.prod.id}"
}
resource "aws_security_group_rule" "web_prod" {
    type              = "ingress"
    from_port         = 443
    to_port           = 443
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.prod.id}"
}
resource "aws_security_group_rule" "from-monitoring-server_prod" {
    type              = "ingress"
    from_port         = xxxx
    to_port           = xxxx
    protocol          = "tcp"
    cidr_blocks       = ["xxx.xxx.xxx.xxx/32"]
    security_group_id = "${aws_security_group.prod.id}"
}
resource "aws_security_group_rule" "from-XXX-ICMP_prod" {
    type              = "ingress"
    from_port         = -1
    to_port           = -1
    protocol          = "ICMP"
    cidr_blocks       = ["xxx.xxx.xxx.xxx/32"]
    security_group_id = "${aws_security_group.prod.id}"
}

resource "aws_security_group_rule" "all_prod" {
    type              = "egress"
    from_port         = 0
    to_port           = 65535
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.prod.id}"
}

## RDS
resource "aws_security_group" "db_prod" {
    name        = "db_server"
    description = "It is a security group on db of sample-vpc."
    vpc_id      = "${aws_vpc.sample-vpc_prod.id}"
    tags {
        Name = "db"
    }
}

resource "aws_security_group_rule" "db_prod" {
    type                     = "ingress"
    from_port                = 3306
    to_port                  = 3306
    protocol                 = "tcp"
    source_security_group_id = "${aws_security_group.prod.id}"
    security_group_id        = "${aws_security_group.db_prod.id}"
}


resource "aws_db_subnet_group" "main_prod" {
    name        = "dbsubnet"
    description = "It is a DB subnet group on sample_vpc."
    subnet_ids  = ["${aws_subnet.private_db1.id}", "${aws_subnet.private_db2.id}"]
    tags {
        Name = "dbsubnet"
    }
}
