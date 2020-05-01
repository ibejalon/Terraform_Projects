resource "aws_iam_role" "s3-ib-bucket-role" {
  name               = "s3-ib-bucket-role"
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

resource "aws_iam_instance_profile" "s3-ib-bucket-role-instanceprofile" {
  name = "s3-ib-bucket-role"
  role = aws_iam_role.s3-ib-bucket-role.name
}

resource "aws_iam_role_policy" "s3-ib-bucket-role-policy" {
  name = "s3-ib-bucket-role-policy"
  role = aws_iam_role.s3-ib-bucket-role.id
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
              "arn:aws:s3:::ib-bucket-c29df1",
              "arn:aws:s3:::ib-bucket-c29df1/*"
            ]
        }
    ]
}
EOF

}

