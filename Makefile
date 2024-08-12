.PHONY: help
.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

install: ## Install dependencies
	pip install -r requirements.txt

run_default: ## Run the default configuration
	python main_default.py

run_dev:  ## Run the dev configuration
	python main_dev.py

run_dev_override_false: ## dev without override so environment var overrides
	EXAMPLE_APP_STAGE=foo python main_dev.py

run_dev_override_true: ## Run the dev configuration with override, so .env var overrides
	EXAMPLE_APP_STAGE=foo python main_dev_override.py
