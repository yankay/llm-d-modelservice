# Makefile for llm-d-modelservice

##@ Development
# Paths that need verification during 'make verify'
PATHS_TO_VERIFY := examples/

# Verify that generated files match current state and no untracked files exist
.PHONY: verify
verify: generate
	git --no-pager diff --exit-code $(PATHS_TO_VERIFY)
	if git ls-files --exclude-standard --others $(PATHS_TO_VERIFY) | grep -q . ; then exit 1; fi

##@ Automation
# Generate all required files (meta-target)
.PHONY: generate
generate: generate-example-output

# Generate example output files from Helm chart templates
.PHONY: generate-example-output
generate-example-output:
	hack/generate-example-output.sh
