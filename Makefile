.PHONY: up down play test lint logs help

SCENARIO ?= 01-rolling-deploy
LINT_IMAGE = ghcr.io/ansible/community-ansible-dev-tools:latest

help:
	@echo "Targets:"
	@echo "  make up                       Build and start the lab (waits for healthy)"
	@echo "  make play [SCENARIO=...]      Run one scenario (default: 01-rolling-deploy)"
	@echo "  make test                     Run all scenarios in order"
	@echo "  make lint                     Run ansible-lint in a container"
	@echo "  make logs                     Tail compose logs"
	@echo "  make down                     Stop the lab and remove volumes"

up:
	docker compose up -d --build --wait

play:
	docker exec ansible_host ansible-playbook \
		-i /workspace/inventory/hosts.ini \
		/workspace/scenarios/$(SCENARIO)/playbook.yml

test:
	$(MAKE) play SCENARIO=01-rolling-deploy
	$(MAKE) play SCENARIO=02-rollback

lint:
	docker run --rm -v "$(CURDIR)":/data -w /data $(LINT_IMAGE) ansible-lint

logs:
	docker compose logs

down:
	docker compose down -v
