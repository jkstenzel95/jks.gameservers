output "arn" {
    description = "the arn of the created bucket"
    value = aws_s3_bucket.bucket.arn
}