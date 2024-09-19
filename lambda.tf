resource "aws_lambda_function" "post_news" {
  function_name = "PostNewsFunction"

  s3_bucket        = "newsfeed-lambda-code-bucket"  # Replace with your S3 bucket
  s3_key           = "lambda/post_news.zip"     # Path to the Lambda ZIP file
  handler          = "bootstrap"
  runtime          = "provided.al2023"  # Go runtime

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.news_table.name
    }
  }

  role = aws_iam_role.lambda_exec_role.arn
}

resource "aws_lambda_function" "get_news" {
  function_name = "GetNewsFunction"

  s3_bucket        = "newsfeed-lambda-code-bucket"  # Replace with your S3 bucket
  s3_key           = "lambda/get_news.zip"      # Path to the Lambda ZIP file
  handler          = "bootstrap"
  runtime          = "provided.al2023"  # Go runtime

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.news_table.name
    }
  }

  role = aws_iam_role.lambda_exec_role.arn
}
