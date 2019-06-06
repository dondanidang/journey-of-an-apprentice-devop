provider "aws" {
  region = "eu-west-1"
  profile = "dondanidang"
}

resource "aws_autosacling_group" "terraform-cluster" {
  launch_configuration  = "${aws_launch_configuration.ec2-instance-configuration-of-cluster.id}"

  # Availability for robustness
  availability_zones  = ["${data.aws_availability_zones.all.names}"]

  # Attach load balancer
  load_balancers      = ["${aws_elb.terraform-cluster-elb.name}"]
  health_check_type   = "ELB"

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



# Load balancer
# Configure ELB
resource "aws_elb" "terraform-cluster-elb" {
    name                = "terraform-asg-with-elb-example"

    # Work accross all the zones of my region
    availability_zones  = ["${data.aws_availability_zones.all.names}"]

    # Attach security group to elb. Indicate to ELB inbound and outbound requests are allowed
    security_group      = ["${aws_security_group.terraform-cluster-elb.id}"]

    # Indicate ELB how to route the request
    # Redirect http request on port 80 to instances port in ASG
    listener {
      lb_port = 80
      lb_protocol = "http"
      instance_port = "${var.server_port}"
      instance_protocol = "http"
    }

    # Add heath check so that the load balance stop redirect requests to instance that are down
    health_check {
      healthy_threshold = 2
      unhealthy_threshold = 2
      timeout = 3
      target = "HTTP:${var.server_port}/"
      interval = 30
    }
}

# Configure ELB security group to allow incoming request
resource "aws_security_group" "terraform-cluster-elb" {
  name = "terraform-asg-with-elb-example"

  # For elb listener
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "http"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # for elb health_checker
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
