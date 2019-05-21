resource "aws_elb" "elb_prod" {
  name = "elb_prod"
  subnets = [
    "${aws_subnet.public_1.id}",
  ]
  security_groups = [
    "${aws_security_group.prod.id}",
  ]
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
    target = "HTTP:80/"
    interval = 30
  }
  instances = ["${aws_instance.web_prod.*.id}"]
  cross_zone_load_balancing = true
  connection_draining = true
  connection_draining_timeout = 400
  tags {
    Name = "sample-elb"
  }
}
