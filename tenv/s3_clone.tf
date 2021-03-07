resource "aws_s3_bucket" "nbnb-clone-j1" {
  bucket = "nbnb-clone-j1"


  tags = {
    Name        = "nbnb-clone-j1"
    Environment = "Dev"
  }
}