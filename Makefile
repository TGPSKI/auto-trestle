# insipired by chassing/qontract-development-cli
PYDIR := auto_trestle
CONTAINERDIR := containers

POETRY_VERSION=1.5.1
GIT_SHA := $(GIT_SHA)

format:
	poetry run black $(PYDIR)
	poetry run isort $(PYDIR)
.PHONY: format

build:
	docker build -t auto-trestle:$(GIT_SHA) -f $(CONTAINERDIR)/Dockerfile .
.PHONY: build