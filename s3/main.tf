provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "youtube-project-samka-1"

  tags = {
    Name        = "DevOpsMaster"
    Environment = "Dev"
  }
}
