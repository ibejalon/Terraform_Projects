resource "aws_s3_bucket" "udagram" {
  bucket = "udagram-asdf1234"
  acl    = "private"

  tags = {
    Name = "udagram-asdf1234"
  }
}

