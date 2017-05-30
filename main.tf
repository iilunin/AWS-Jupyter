provider "aws"{
  region = "us-east-1"
}

variable "jupyter_ami"{
	default = "ami-5a45504d"
}

variable "keyfile"{
	default = "jupyter.pub"
}

variable "jupyter_instance_type"{
	default = "t2.small"
}

resource "aws_security_group" "jupyter_security_group" {

	name = "Jupyter Security Group"

	# SSH access from anywhere
	ingress {
		from_port   = 22
		to_port     = 22
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	# HTTP access from anywhere
	ingress {
		from_port   = 80
		to_port     = 80
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	# HTTP access from anywhere
	ingress {
		from_port   = 8888
		to_port     = 8888
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

  ingress {
		from_port   = 2049
		to_port     = 2049
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	# outbound internet access
	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
	Name = "Jupyter"}
}


resource "aws_key_pair" "jupyter_auth" {
  key_name   = "${var.keyfile}"
  public_key = "${file(var.keyfile)}"
}


#TODO: add default IAM role

resource "aws_instance" "jupyter_host" {
	ami           = "${var.jupyter_ami}"
	instance_type = "${var.jupyter_instance_type}"

	key_name = "${aws_key_pair.jupyter_auth.id}"

	vpc_security_group_ids = ["${aws_security_group.jupyter_security_group.id}"]

	tags =
	{Name = "Jupyter"}

	user_data = <<EOF
	#!/bin/bash
	sudo yum update -y
	sh /home/ec2-user/first_sync.sh
	EOF

	iam_instance_profile = "${aws_iam_instance_profile.jupyter_profile.id}"
}

output "jupyter_ssh"{
	value = "ssh -i \"jupyter.pem\" ec2-user@${aws_instance.jupyter_host.public_ip}"
}


output "jupyter_web"{
	value = "http://${aws_instance.jupyter_host.public_ip}:8888"
}
