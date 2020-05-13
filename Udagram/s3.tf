resource "aws_s3_bucket" "udagram-bucket" {
  bucket = "udagram-bucket-asdf1234"
  acl    = "private"

  tags = {
    Name = "udagram-bucket-asdf1234"
  }
}

