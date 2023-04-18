###########################################
# Run AVD with various tags               #
# #########################################

.PHONY: help
help: ## Display help message
	@grep -E '^[0-9a-zA-Z_-]+\.*[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build: ## Build AVD Configs
	ansible-playbook playbooks/build.yml -i sites/site1/inventory.yml

.PHONY: deploy_cvp
deploy_cvp: ## Deploy AVD configs via CVP
	ansible-playbook playbooks/deploy_cvp.yml -i sites/site1/inventory.yml

.PHONY: deploy_eapi
deploy_eapi: ## Deploy AVD configs via eAPI
	ansible-playbook playbooks/deploy_eapi.yml -i sites/site1/inventory.yml