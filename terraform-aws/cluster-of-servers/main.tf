provider "aws" {
  region = "eu-west-1"
  profile = "dondanidang"
}

resource "aws_autosacling_group" "terraform-cluster" {
  launch_configuration  = "${aws_launch_configuration.ec2-instance-configuration-of-cluster.id}"

  # Availability for robustness
  availability_zones    = "${data.availability_zones.all.names}"
  min_size              = 2
  max_size              = 10

  tag {
    key                 = "Name"
    Value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}

# Configuration of each EC2
resource "aws_launch_configuration" "ec2-instance-configuration-of-cluster" {
  # Configuration of the EC2
  ami             = "ami-08d658f84a6d84a80"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.instance.id}"]

  user_data       = <<-EOF
                    #!/bin/bash
                    echo "Hello guys, I am Daniel launching a cluster of servers" > index.html
                    nohub busybox httpd -f -p "${var.server_port}" &
                    EOF

  tags {
    Name = "terraform-example"
  }

  # meta-parameter that indicate how the resource will be replace
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_availability_zones" "all" {}


# Define security group and it rules
resource "aws_security_group" "instance" {
    name = "terraform-cluster-of-server"

    ingress {
      from_port   = "${var.server_port}"
      to_port     = "${var.server_port}"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    # Same lifecycle as the resource that depends on it. Otherwise, we will get lifecycle dependencies error
    lifecycle {
      create_before_destroy = true
    }
}
