provider "aws"{
  region = "us-east-1"
}

resource "aws_iam_instance_profile" "salt_master_packer_profile" {
    name = "packer_profile"
    roles = ["${aws_iam_role.packer_role.name}"]
}

resource "aws_iam_role" "packer_role" {
    name = "packer_ami_role"
    path = "/"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}


resource "aws_iam_role_policy" "packer_ami_policy" {
    name = "packer_ami_policy"
    role = "${aws_iam_role.packer_role.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF
}