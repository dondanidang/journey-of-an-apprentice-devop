output "public_ip" {
  value = "${aws_instance.test-sample.public_ip}"
}
