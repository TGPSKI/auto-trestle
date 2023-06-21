# insipired by chassing/qontract-development-cli and app-sre/qontract-reconcile
PYDIR := auto_trestle
CONTAINERDIR := containers
POETRY_VERSION=1.5.1
GIT_SHA := $(shell git rev-parse --short=7 HEAD)

CONTAINER_ENGINE ?= $(shell which podman >/dev/null 2>&1 && echo podman || echo docker)
CONTAINER_UID ?= $(shell id -u)

include .env-dev

bootstrap-fixtures:
	#@./hack/bootstrap-fixtures-oscal.sh $(CONTROLS_REVISION) $(CONTROLS_GIT_REPO) $(CONTROLS_CONTENT_DIR)
	@./hack/bootstrap-trestle.sh $(INTERFACE_CONTENT_DIR) $(CONTROLS_REVISION)
.PHONY: bootstrap-fixtures

format:
	poetry run black $(PYDIR)
	poetry run isort $(PYDIR)
.PHONY: format

build:
	docker build -t auto-trestle:$(GIT_SHA) -f $(CONTAINERDIR)/Dockerfile .
.PHONY: build

# https://github.com/python-poetry/poetry/issues/994#issuecomment-831598242
# Check for CVEs
check-cve:
	poetry export -f requirements.txt --without-hashes | poetry run safety check --stdin
.PHONY: check-cve