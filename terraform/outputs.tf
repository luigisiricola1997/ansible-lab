output "bucket" {
  description = "Name of the S3 bucket where Ansible publishes deployment artifacts."
  value       = module.ansible_lab.bucket_name
}

output "secret_name" {
  description = "Name of the SecretsManager secret consumed by the Ansible playbook."
  value       = module.ansible_lab.secret_name
}
