terraform {
    backend "s3" {
        bucket = "terraform-state-IB1"
        key = "terraform-practice/remote-state"
        region = "us-east-2"
    }
}