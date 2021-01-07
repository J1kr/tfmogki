resource "aws_s3_bucket" "main" {
  bucket = "j1-terraform-101"

  tags = {
    Name        = "j1-terraform-101"
  }
}