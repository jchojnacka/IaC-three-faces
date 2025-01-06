output "website_url" {
  description = "Access your static HTML page from this S3 bucket website endpoint."
  value       = "http://${aws_s3_bucket.my_website_bucket.bucket}.s3-website.${var.region}.amazonaws.com"
}

output "api_endpoint" {
  description = "Invoke the Lambda by sending a GET request to /hello"
  value       = format("https://%s.execute-api.%s.amazonaws.com/%s/hello", aws_api_gateway_rest_api.my_api_gateway.id, var.region, aws_api_gateway_stage.my_api_stage.stage_name)
}
