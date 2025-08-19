
TOOLS_DIR := $(PROJECT_DIR)/bin

##@ Tools

HELM = $(TOOLS_DIR)/helm
$(HELM):
	hack/install-tools.sh helm

.PHONY: helm
helm: $(HELM) ## Install Helm tool

CT = $(TOOLS_DIR)/ct
$(CT):
	hack/install-tools.sh ct

.PHONY: ct
ct: $(CT) ## Install Chart Testing (ct) tool
