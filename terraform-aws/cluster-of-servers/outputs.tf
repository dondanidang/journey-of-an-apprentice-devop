# To display elb dns name
output "elb_dns_name" {
  value = "${aws_elb.terraform-cluster-elb.dns_name}"
}
