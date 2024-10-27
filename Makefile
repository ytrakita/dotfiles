BIN_PATH := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))/bin

.DEFAULT_GOAL := help

.PHONY: all clean deploy help init

all:

clean: ## Remove all symlinks to this repository.
	@$(BIN_PATH)/clean.sh

deploy: ## Put symlinks of config files.
	@$(BIN_PATH)/deploy.sh

update: ## Update config files.
	@$(BIN_PATH)/update.sh

init: ## Initialize config files.
	@$(BIN_PATH)/init.sh

help: ## Display this help.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-8s\033[0m %s\n", $$1, $$2}'
