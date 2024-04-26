terraform {
  backend "s3" {
    bucket = "youtube-project-samka-1"
    key    = "jenkins/terraform.tfstate"
    region = "us-east-1"
  }
}