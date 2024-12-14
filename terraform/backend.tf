terraform {
  backend "s3" {
    bucket = "ramratan-bucket-2510"
    key    = "terraform/state.tfstate"
    region = "us-east-1"
  }
}
