# IAM role
resource "aws_iam_role" "hello-app-ec2-role" {
  name               = "hello-app-ec2-role"
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

resource "aws_iam_instance_profile" "hello-app-ec2-role" {
  name = "hello-app-ec2-role"
  role = aws_iam_role.hello-app-ec2-role.name
}

# Service
resource "aws_iam_role" "elasticbeanstalk-service-role" {
  name = "elasticbeanstalk-service-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "elasticbeanstalk.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

# Policies
resource "aws_iam_policy_attachment" "hello-app-attach1" {
name       = "hello-app-attach1"
roles      = [aws_iam_role.hello-app-ec2-role.name]
policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_policy_attachment" "hello-app-attach2" {
name       = "hello-app-attach2"
roles      = [aws_iam_role.hello-app-ec2-role.name]
policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}

resource "aws_iam_policy_attachment" "hello-app-attach3" {
name       = "hello-app-attach3"
roles      = [aws_iam_role.hello-app-ec2-role.name]
policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

resource "aws_iam_policy_attachment" "hello-app-attach4" {
name       = "hello-app-attach4"
roles      = [aws_iam_role.elasticbeanstalk-service-role.name]
policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}

