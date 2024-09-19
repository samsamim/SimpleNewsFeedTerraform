resource "aws_api_gateway_rest_api" "news_api" {
  name        = "NewsAPI"
  description = "API for posting and retrieving news"
}

# POST NEWS
resource "aws_api_gateway_resource" "post_news" {
  rest_api_id = aws_api_gateway_rest_api.news_api.id
  parent_id   = aws_api_gateway_rest_api.news_api.root_resource_id
  path_part   = "postNews"
}

resource "aws_api_gateway_method" "post_news" {
  rest_api_id   = aws_api_gateway_rest_api.news_api.id
  resource_id   = aws_api_gateway_resource.post_news.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_news" {
  rest_api_id             = aws_api_gateway_rest_api.news_api.id
  resource_id             = aws_api_gateway_resource.post_news.id
  http_method             = aws_api_gateway_method.post_news.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${aws_lambda_function.post_news.arn}/invocations"
}

resource "aws_api_gateway_method_response" "post_news" {
  rest_api_id = aws_api_gateway_rest_api.news_api.id
  resource_id = aws_api_gateway_resource.post_news.id
  http_method = "POST"
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration_response" "post_news" {
  rest_api_id = aws_api_gateway_rest_api.news_api.id
  resource_id = aws_api_gateway_resource.post_news.id
  http_method = "POST"
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'http://my-news-feed-frontend.s3.us-east-1.amazonaws.com'"
    "method.response.header.Access-Control-Allow-Methods" = "'POST,GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type'"
  }

  depends_on = [aws_api_gateway_integration.post_news]
}

# GET NEWS
resource "aws_api_gateway_resource" "get_news" {
  rest_api_id = aws_api_gateway_rest_api.news_api.id
  parent_id   = aws_api_gateway_rest_api.news_api.root_resource_id
  path_part   = "getNews"
}

resource "aws_api_gateway_method" "get_news" {
  rest_api_id   = aws_api_gateway_rest_api.news_api.id
  resource_id   = aws_api_gateway_resource.get_news.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_news" {
  rest_api_id             = aws_api_gateway_rest_api.news_api.id
  resource_id             = aws_api_gateway_resource.get_news.id
  http_method             = aws_api_gateway_method.get_news.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${aws_lambda_function.get_news.arn}/invocations"
}

resource "aws_api_gateway_method_response" "get_news" {
  rest_api_id = aws_api_gateway_rest_api.news_api.id
  resource_id = aws_api_gateway_resource.get_news.id
  http_method = "GET"
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration_response" "get_news" {
  rest_api_id = aws_api_gateway_rest_api.news_api.id
  resource_id = aws_api_gateway_resource.get_news.id
  http_method = "GET"
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'http://my-news-feed-frontend.s3.us-east-1.amazonaws.com'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type'"
  }

  depends_on = [aws_api_gateway_integration.get_news]
}

//OPTIONS SET UP:
resource "aws_api_gateway_method" "options_post_news" {
  rest_api_id   = aws_api_gateway_rest_api.news_api.id
  resource_id   = aws_api_gateway_resource.post_news.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_post_news" {
  rest_api_id = aws_api_gateway_rest_api.news_api.id
  resource_id = aws_api_gateway_resource.post_news.id
  http_method = aws_api_gateway_method.options_post_news.http_method
  type        = "MOCK"

  integration_http_method = "OPTIONS"
  passthrough_behavior     = "NEVER"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}


resource "aws_api_gateway_integration_response" "options_post_news" {
  rest_api_id = aws_api_gateway_rest_api.news_api.id
  resource_id = aws_api_gateway_resource.post_news.id
  http_method = aws_api_gateway_method.options_post_news.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'http://my-news-feed-frontend.s3.us-east-1.amazonaws.com'"
    "method.response.header.Access-Control-Allow-Methods" = "'POST,GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type'"
  }

  depends_on = [aws_api_gateway_integration.options_post_news]
}

resource "aws_api_gateway_method_response" "options_post_news" {
  rest_api_id = aws_api_gateway_rest_api.news_api.id
  resource_id = aws_api_gateway_resource.post_news.id
  http_method = aws_api_gateway_method.options_post_news.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

# DEPLOYMENT CONFIG
resource "aws_api_gateway_deployment" "news_api" {
  depends_on = [
    aws_api_gateway_method.post_news,
    aws_api_gateway_method.get_news,
    aws_api_gateway_integration.post_news,
    aws_api_gateway_integration.get_news,
    aws_api_gateway_method_response.post_news,
    aws_api_gateway_method_response.get_news,
    aws_api_gateway_integration_response.post_news,
    aws_api_gateway_integration_response.get_news,
    aws_api_gateway_method.options_post_news, 
    aws_api_gateway_integration.options_post_news,
    aws_api_gateway_method_response.options_post_news, 
    aws_api_gateway_integration_response.options_post_news,
  ]
  rest_api_id = aws_api_gateway_rest_api.news_api.id
  stage_name  = "prod"
}
