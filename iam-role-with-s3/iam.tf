resource "aws_iam_role" "s3-azbucket-role" {
  name               = "s3-azbucket-role"
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

resource "aws_iam_instance_profile" "s3-azbucket-role-instanceprofile" {
  name = "s3-azbucket-role"
  role = aws_iam_role.s3-azbucket-role.name
}

resource "aws_iam_role_policy" "s3-azbucket-role-policy" {
  name = "s3-azbucket-role-policy"
  role = aws_iam_role.s3-azbucket-role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "s3:*"
            ],
            "Resource": [
              "arn:aws:s3:::azbucket-c29df1",
              "arn:aws:s3:::azbucket-c29df1/*"
            ]
        }
    ]
}
EOF

}

