resource "aws_s3_bucket" "ib-bucket" {
  bucket = "ib-bucket-asdf123"
  acl    = "private"

  tags = {
    Name = "ib-bucket-asdf123"
  }
}

