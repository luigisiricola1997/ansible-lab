locals {
  bucket_name = "${var.name}-artifacts"
  secret_name = "${var.name}/welcome-message"
}

resource "aws_s3_bucket" "artifacts" {
  bucket        = local.bucket_name
  force_destroy = true
}

resource "aws_secretsmanager_secret" "welcome" {
  name                    = local.secret_name
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "welcome" {
  secret_id     = aws_secretsmanager_secret.welcome.id
  secret_string = var.welcome_message
}
