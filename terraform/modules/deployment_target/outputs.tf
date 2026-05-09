output "bucket_name" {
  description = "Name of the S3 bucket created for deployment artifacts."
  value       = aws_s3_bucket.artifacts.bucket
}

output "secret_name" {
  description = "Name of the SecretsManager secret consumed by Ansible."
  value       = aws_secretsmanager_secret.welcome.name
}

output "secret_arn" {
  description = "ARN of the SecretsManager secret. Useful for IAM policy bindings on the consuming workload."
  value       = aws_secretsmanager_secret.welcome.arn
}
