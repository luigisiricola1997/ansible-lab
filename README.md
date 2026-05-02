# ansible-lab

![CI](https://github.com/luigisiricola1997/ansible-lab/actions/workflows/test.yml/badge.svg)

Test rolling, parallel, and serial deployment patterns for Ansible locally,
across RHEL and Ubuntu. No VMs, no cloud, no waiting. 30 seconds to a
6-host hybrid lab.

## Who is this for

You write Ansible roles and want to test multi-host patterns
(`serial`, handlers, `block`/`rescue`, health gates) and cross-distro
behavior (RHEL UBI9 + Ubuntu 24.04) without spinning up VMs or cloud
instances.
Everything runs on your laptop in containers.

## Quickstart

```sh
make up        # build and start the lab
make test      # run all scenarios
make down      # stop and clean up
```

Run a single scenario: `make play SCENARIO=02-rollback`. See `make help` for all targets.

## Hosts

- 4 RHEL UBI9 targets (`target_host1` to `target_host4`)
- 2 Ubuntu 24.04 LTS targets (`target_host5`, `target_host6`)
- 1 Ansible controller (`ansible_host`)

The `nginx` role is **single-source**: it uses `ansible.builtin.package` plus OS-specific vars loaded via `include_vars` keyed on `ansible_facts['os_family'`, so the same playbook installs and configures nginx on both distros without any duplication.

## Scenarios included

- **`01-rolling-deploy`**: nginx deployed across all 6 target hosts in batches of 2 (`serial: 2`), with a templated index page, a `Reload nginx` handler, and a `wait_for` health gate after each batch. The canonical rolling-deploy pattern, exercised cross-distro.

- **`02-rollback`**: same `serial: 2` rollout, but with `block`/`rescue` that restores the previous config when validation fails.
  One target (`target_host3`) has `simulate_failure=true` set in the inventory, so the rollback path is exercised in CI on every commit.

## FAQ

**Why Docker Compose and not Kubernetes?**
Ansible's pet-host model (SSH onto persistent hosts, imperative state) is the opposite of Kubernetes' immutable-pod model. Running sshd plus a service inside a privileged pod is fighting the platform. Docker Compose is the right tool for a host-level lab. Use the right tool for the problem.

**Why `privileged: true` on the targets?**
Required to run systemd as PID 1 inside the container, plus install packages with `dnf` (RHEL) or `apt` (Ubuntu). This is a lab, not a production runtime.

**Why UBI9 and Ubuntu together?**
Real fleets are rarely homogeneous. Having both lets you verify that a role is actually cross-distro (the `package`/`service` modules plus `include_vars` pattern), not just RHEL-only with a green CI.

**How do I add more target hosts?**
Add another `target_hostN:` service in `docker-compose.yml` re-using either the `x-target-host-redhat` or `x-target-host-ubuntu` anchor, then append the hostname to the matching group in `inventory/hosts.ini`.

**Where are SSH keys stored?**
A shared Docker volume `ssh_keys` is mounted as `/root/.ssh` on every container.
The `ansible_host` generates a keypair at startup; each target picks up the public key and writes it to `authorized_keys`.

## License

GPL-3.0. See [LICENSE](LICENSE).
