provider "aws" {
  region = "eu-west-1"
  profile = "dondanidang"
}

resource "aws_instance" "test-sample" {
  ami = "ami-08d658f84a6d84a80"
  instance_type = "t2.micro"
  # Link security group to this instance
  vpc_security_group_ids=["${aws_security_group.instance.id}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello guys, I am Daniel from learning terraform" > index.html
              nohub busybox httpd -f -p "${var.server_port}" &
              EOF

  tags {
    Name = "terraform-example"
  }
}

# Define security group and it rules
resource "aws_security_group" "instance" {
    name = "terraform-configurable-server-instance"

    ingress {
      from_port = "${var.server_port}"
      to_port = "${var.server_port}"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
}
