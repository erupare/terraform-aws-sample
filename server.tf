# AMI images id
# ami-07ad4b1c3af1ea214 # Ubuntu Server 18.04 LTS (HVM), SSD Volume Type
# ami-06c43a7df16e8213c # Ubuntu Server 16.04 LTS (HVM), SSD Volume Type


# RDS Instance
resource "aws_db_instance" "db_prod" {
    identifier              = "sampledbinstance"
    allocated_storage       = 50
    engine                  = "mysql"
    engine_version          = "5.7.22"
    instance_class          = "db.m4.large"
    storage_type            = "gp2"
    username                = "${var.aws_db_username}"
    password                = "${var.aws_db_password}"
    backup_retention_period = 1
    vpc_security_group_ids  = ["${aws_security_group.db.id}"]
    db_subnet_group_name    = "${aws_db_subnet_group.main.name}"
    parameter_group_name = "${aws_db_parameter_group.sample.name}"
#    timezone                = "Asia/Tokyo"
#    backup_retention_period = "7"
#    backup_window           = "22:29-22:59"
    apply_immediately       = "true"
}

output "rds_endpoint" {
    value = "${aws_db_instance.db.address}"
}


# EC2 Instance
## WEB
resource "aws_instance" "web_prod" {
    count                       = "${var.web_servers_count}"
    ami                         = "ami-940cdceb"  # [Ubuntu Server 16.04 LTS (HVM), SSD Volume Type]
    instance_type               = "t2.micro"
    key_name                    = "${var.key_name}"  # EC2 に登録済の Key Pairs を指定する
    vpc_security_group_ids      = ["${aws_security_group.prod.id}"]
    subnet_id                   = "${aws_subnet.public_1.id}"
    associate_public_ip_address = "true"
    root_block_device = {
        volume_type = "gp2"
        volume_size = "20"
    }
    tags {
        Name = "${format("ap-sample-web%02d", count.index + 1)}"
    }
}
### WEB Elastic IP
resource "aws_eip" "web_prod" {
    count                       = "${var.web_servers_count}"
    instance                    = "${element(aws_instance.web.*.id, count.index)}"
    vpc                         = true
}
output "IPADDRESS_web" {
  value = "${join(", ", aws_eip.web.*.public_ip)}"
}

## Batch
resource "aws_instance" "batch_prod" {
    ami                         = "ami-940cdceb"  # [Ubuntu Server 16.04 LTS (HVM), SSD Volume Type]
    instance_type               = "t2.xlarge"
    key_name                    = "${var.key_name}"  # EC2 に登録済の Key Pairs を指定する
    vpc_security_group_ids      = ["${aws_security_group.prod.id}"]
    subnet_id                   = "${aws_subnet.public_1.id}"
    associate_public_ip_address = "true"
    root_block_device = {
        volume_type = "gp2"
        volume_size = "50"
    }
    tags {
        Name = "ap-sample-batch01"
    }
}
### Batch Elastic IP
resource "aws_eip" "batch_prod" {
    instance                    = "${aws_instance.batch.id}"
    vpc                         = true
}
output "IPADDRESS_batch" {
    value = "${aws_eip.batch.public_ip}"
}
