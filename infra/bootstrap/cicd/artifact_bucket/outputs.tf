output "name" {
    description = "the bucket created"
    value = aws_s3_bucket.artifact_bucket.id
}