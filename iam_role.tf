resource "aws_iam_instance_profile" "jupyter_profile" {
    name = "jupyter_profile"
    roles = ["${aws_iam_role.jupyter_role.name}"]
}

resource "aws_iam_role" "jupyter_role" {
    name = "jupyter_role"
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


resource "aws_iam_role_policy" "jupyter_policy" {
    name = "jupyter_policy"
    role = "${aws_iam_role.jupyter_role.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "NotAction": "iam:*",
      "Resource": "*"
    }
  ]
}
EOF
}
