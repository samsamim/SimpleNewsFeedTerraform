resource "aws_lambda_permission" "post_news" {
  statement_id  = "AllowExecutionFromAPIGatewayPostNews"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.post_news.function_name
  principal     = "apigateway.amazonaws.com"

  # The source ARN should be scoped to the specific API Gateway
  source_arn = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.news_api.id}/*/*/postNews"
}

resource "aws_lambda_permission" "get_news" {
  statement_id  = "AllowExecutionFromAPIGatewayGetNews"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_news.function_name
  principal     = "apigateway.amazonaws.com"

  # The source ARN should be scoped to the specific API Gateway
  source_arn = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.news_api.id}/*/*/getNews"
}

