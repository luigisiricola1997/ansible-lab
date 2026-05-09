.PHONY: up down play test test-ansible test-cloud lint logs help tf-up tf-down tf-fmt molecule ci-local

scenario ?= 01-rolling-deploy
LINT_IMAGE = ghcr.io/ansible/community-ansible-dev-tools:latest
TF_IMAGE = hashicorp/terraform:1.10
NETWORK = ansible-lab-network

ANSIBLE_PLAYBOOK = docker exec ansible_host ansible-playbook
playbook = $(if $(filter %.yml,$(scenario)),$(scenario),playbooks/$(scenario).yml)

help:
	@echo "Targets:"
	@echo "  make up                       Build and start the lab (waits for healthy)"
	@echo "  make play [scenario=...]      Run a playbook. scenario is either a name"
	@echo "                                (e.g. 02-rollback -> playbooks/02-rollback.yml)"
	@echo "                                or a .yml path relative to project root"
	@echo "                                (e.g. playbooks/03-cloud-integration.yml)"
	@echo "  make test                     Run all scenarios in order"
	@echo "  make test-ansible             Run scenarios 01-02 (no cloud)"
	@echo "  make test-cloud               Apply terraform, run scenario 03, destroy"
	@echo "  make tf-up                    Apply terraform/ against LocalStack"
	@echo "  make tf-down                  Destroy terraform-managed resources"
	@echo "  make tf-fmt                   Format terraform/ recursively"
	@echo "  make lint                     Run ansible-lint in a container"
	@echo "  make molecule                 Run Molecule tests for all roles (needs molecule-plugins[docker])"
	@echo "  make ci-local                 Run lint + molecule + integration locally (mirrors CI)"
	@echo "  make logs                     Tail compose logs"
	@echo "  make down                     Stop the lab, remove volumes and tfstate"

up:
	docker compose up -d --build --wait

play:
	$(ANSIBLE_PLAYBOOK) $(playbook)

test: test-ansible test-cloud

test-ansible:
	$(MAKE) play scenario=01-rolling-deploy
	$(MAKE) play scenario=02-rollback

test-cloud:
	$(MAKE) tf-up
	$(MAKE) play scenario=03-cloud-integration
	$(MAKE) tf-down

TF_RUN = docker run --rm -u $(shell id -u):$(shell id -g) \
	-v "$(CURDIR)/terraform":/tf -w /tf $(TF_IMAGE)
TF_RUN_NET = docker run --rm -u $(shell id -u):$(shell id -g) --network $(NETWORK) \
	-v "$(CURDIR)/terraform":/tf -w /tf $(TF_IMAGE)

tf-up:
	$(TF_RUN_NET) init -input=false
	$(TF_RUN_NET) apply -auto-approve -input=false

tf-down:
	$(TF_RUN_NET) destroy -auto-approve -input=false

tf-fmt:
	$(TF_RUN) fmt -recursive

lint:
	docker run --rm -v "$(CURDIR)":/data -w /data $(LINT_IMAGE) sh -c \
		"ansible-galaxy collection install -r requirements.yml && ansible-lint"

molecule:
	@command -v molecule >/dev/null || { echo "molecule not found. Install: pip install 'molecule-plugins[docker]'"; exit 1; }
	cd roles/nginx && molecule test
	cd roles/deploy && molecule test

ci-local:
	$(MAKE) lint
	$(MAKE) molecule
	$(MAKE) up
	$(MAKE) test
	$(MAKE) down

logs:
	docker compose logs

down:
	docker compose down -v
	rm -rf terraform/.terraform terraform/terraform.tfstate*
