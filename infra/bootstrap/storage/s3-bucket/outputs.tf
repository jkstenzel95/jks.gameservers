output "arn" {
    description = "the arn of the created bucket"
    value = aws_s3_bucket.bucket.arn
}

output "name" {
    description = "the name of the created bucket"
    value = aws_s3_bucket.bucket.id
}