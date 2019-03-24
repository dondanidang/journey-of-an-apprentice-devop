provider "aws" {
  region = "eu-west-1"
  profile = "dondanidang"
}

resource "aws_instance" "test-sample" {
  ami = "ami-08d658f84a6d84a80"
  instance_type = "t2.micro"
  tags {
    Name = "terraform-example"
  }
}
