resource "aws_s3_bucket" "lambda_code_bucket" {
  bucket = "newsfeed-lambda-code-bucket"  # Replace with a unique bucket name

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "lambda_code_bucket_versioning" {
  bucket = aws_s3_bucket.lambda_code_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-news-feed-bucket"  # Ensure this name is globally unique
}
