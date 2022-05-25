{%- set test_cases = cookiecutter.test_cases.split(" ") -%}
# Commodore takes the root dir name as the package name
PACKAGE_NAME ?= $(shell basename ${PWD} | sed s/package-//)

root_volume     ?= -v "$${PWD}:/$(PACKAGE_NAME)"
commodore_args  ?= tests/$(instance).yml

ifneq "$(shell which docker 2>/dev/null)" ""
	DOCKER_CMD    ?= $(shell which docker)
	DOCKER_USERNS ?= ""
else
	DOCKER_CMD    ?= podman
	DOCKER_USERNS ?= keep-id
endif
DOCKER_ARGS ?= run --rm -u "$$(id -u):$$(id -g)" --userns=$(DOCKER_USERNS) -w /$(PACKAGE_NAME) -e HOME="/$(PACKAGE_NAME)"

YAMLLINT_ARGS   ?= --no-warnings
YAMLLINT_CONFIG ?= .yamllint.yml
YAMLLINT_IMAGE  ?= docker.io/cytopia/yamllint:latest
YAMLLINT_DOCKER ?= $(DOCKER_CMD) $(DOCKER_ARGS) $(root_volume) $(YAMLLINT_IMAGE)

VALE_CMD  ?= $(DOCKER_CMD) $(DOCKER_ARGS) $(root_volume) --volume "$${PWD}"/docs/modules:/pages docker.io/vshn/vale:2.1.1
VALE_ARGS ?= --minAlertLevel=error --config=/pages/ROOT/pages/.vale.ini /pages

ANTORA_PREVIEW_CMD ?= $(DOCKER_CMD) run --rm --publish 35729:35729 --publish 2020:2020 --volume "${PWD}/.git":/preview/antora/.git --volume "${PWD}/docs":/preview/antora/docs docker.io/vshn/antora-preview:3.0.1.1 --style=syn --antora=docs


COMMODORE_CMD  ?= $(DOCKER_CMD) $(DOCKER_ARGS) $(root_volume) docker.io/projectsyn/commodore:latest
COMPILE_CMD    ?= $(COMMODORE_CMD) package compile . $(commodore_args)

instance ?= {{ test_cases[0] }}
{%- if cookiecutter.add_golden == "y" %}
test_instances ={% for instance in test_cases %} tests/{{instance}}.yml{% endfor %}
{%- endif %}
