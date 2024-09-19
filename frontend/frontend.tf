# Create the S3 bucket
resource "aws_s3_bucket" "static_website" {
  bucket = "my-news-feed-frontend"
}

# Configure the bucket as a static website
resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.static_website.id

  index_document {
    suffix = "index.html"
  }

  # You can add other settings like error documents if needed
}

# Upload the index.html file to the bucket
resource "aws_s3_object" "index" {
  bucket        = aws_s3_bucket.static_website.id
  key           = "index.html"
  source        = "./index.html"
  content_type  = "text/html"
  etag          = filemd5("./index.html")
}

# Set the bucket policy to allow public access
resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.static_website.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.static_website.arn}/*"
      }
    ]
  })
}

# Output the website URL
output "website_url" {
  value = "http://${aws_s3_bucket.static_website.bucket}.s3-website-${data.aws_region.current.name}.amazonaws.com"
}

# Data source for the current AWS region
data "aws_region" "current" {}
