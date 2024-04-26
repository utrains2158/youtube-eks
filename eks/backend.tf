terraform {
  backend "s3" {
    bucket = "youtube-project-samka-1"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}