output "s3_bucket_web_endpoint" {
  value = "${aws_s3_bucket.admin_bucket.website_endpoint}"
}
