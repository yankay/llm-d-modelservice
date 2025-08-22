# Makefile for llm-d-modelservice
PROJECT_DIR := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))

.PHONY: help
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Development

.PHONY: pre-helm
pre-helm: ## Set up Helm dependency repositories
	helm repo add bitnami https://charts.bitnami.com/bitnami

.PHONY: lint
lint: pre-helm ## Run lint checks using helm-lint
	ct lint --check-version-increment=false --validate-maintainers=false --charts charts/llm-d-modelservice $(if $(TARGET_BRANCH),--target-branch $(TARGET_BRANCH))

# Paths that need verification during 'make verify'
PATHS_TO_VERIFY := examples/

.PHONY: verify
verify: generate ## Verify that generated files match current state
	git --no-pager diff --exit-code $(PATHS_TO_VERIFY)
	if git ls-files --exclude-standard --others $(PATHS_TO_VERIFY) | grep -q . ; then exit 1; fi

##@ Automation

.PHONY: generate
generate: ## Generate example output files from Helm chart templates
	hack/generate-example-output.sh

