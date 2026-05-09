# ansible-lab

![CI](https://github.com/luigisiricola1997/ansible-lab/actions/workflows/test.yml/badge.svg)

Multi-host Ansible deployment patterns (rolling, rollback, cross-distro) plus Terraform-to-Ansible handoff against an emulated AWS, all in containers - no VMs, no cloud account.

## Quickstart

```sh
make up                  # 6 targets + controller + LocalStack
make test                # all scenarios
make down                # stop, clean volumes and tfstate
```

Subsets: `make test-ansible`, `make test-cloud`.
Single scenario: `make play scenario=02-rollback`.

## Layout

Containers: 4 RHEL UBI9 + 2 Ubuntu 24.04 targets, 1 Ansible controller, 1 LocalStack (S3 + SecretsManager on `:4566`).
Code: `roles/{nginx,deploy}`, `playbooks/`, `terraform/` (root + local module `modules/deployment_target`), `inventory/`, `ansible.cfg`.

## Scenarios

- **`01-rolling-deploy`**: nginx across 6 hosts in batches of 2 (`serial: 2`), templated index, handlers, health gate, cross-distro via `include_vars` on `os_family`.
- **`02-rollback`**: same rollout with `block`/`rescue` restoring the previous config on failure; `target_host3` carries `simulate_failure=true` so the rescue path runs every CI build.
- **`03-cloud-integration`**: Terraform provisions S3 + SecretsManager in LocalStack; Ansible reads the secret via `amazon.aws.aws_secret` and pushes an HTML artifact to S3 via `amazon.aws.s3_object`.

After scenario 03 the artifact is at `http://localhost:4566/ansible-lab-artifacts/index.html`.

## Testing

Integration tests on the multi-host lab via `make test-ansible` (scenarios 01-02 across the 6-host fleet) and `make test-cloud` (Terraform provision + scenario 03 + destroy).
Both run in CI in parallel after lint.

## FAQ

**Why Docker Compose and not Kubernetes?**
Ansible's pet-host SSH model is the opposite of K8s' immutable-pod model.

**Why `privileged: true` on targets?**
Needed for systemd as PID 1 plus `dnf`/`apt`.

**Why LocalStack and not real AWS?**
Zero cost, fully offline; Terraform's AWS provider and the `amazon.aws` collection both honor `AWS_ENDPOINT_URL`, so the code is identical to real AWS.

## License

GPL-3.0.
