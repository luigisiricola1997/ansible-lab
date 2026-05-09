variable "name" {
  description = "Logical name of the deployment target. Used as prefix for the artifact bucket (\"<name>-artifacts\") and the welcome-message secret (\"<name>/welcome-message\")."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.name))
    error_message = "name must be lowercase alphanumeric with dashes only (S3 bucket-naming rules: no underscores, no leading/trailing dashes)."
  }
}

variable "welcome_message" {
  description = "String stored in SecretsManager and consumed by the Ansible playbook to render the deployment artifact."
  type        = string
}
