terraform {
  backend "s3" {
    bucket         = "terraform-news-feed-bucket"
    key            = "terraform/state.tfstate"
    region         = "us-east-1"
  }
}

# Data source to retrieve current AWS account ID
data "aws_caller_identity" "current" {}

# Data source to retrieve current AWS region
data "aws_region" "current" {}
