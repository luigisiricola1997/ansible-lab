module "ansible_lab" {
  source = "./modules/deployment_target"

  name            = "ansible-lab"
  welcome_message = "Hello from LocalStack -- provisioned by Terraform, deployed by Ansible"
}
