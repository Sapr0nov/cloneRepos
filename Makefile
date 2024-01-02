MAKEFLAGS += --no-print-directory
SHELL = /bin/bash
UID = $(shell id -u)

include .env

.DEFAULT: help

help:  ## Display command list
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

gitInit:
	git init $(subst .git,,$(value))

remoteAdd:
	@cd $(subst .git,,$(value)) && git remote add $(subst .git,,$(value)) https://$(TARGET_URL)$(value)
	@cd $(subst .git,,$(value)) && git fetch origin master
	@cd $(subst .git,,$(value)) && git checkout -b $(NEW_BRANCH) origin/master

gitPush:
	@cd $(subst .git,,$(value)) && git push https://$(TARGET_USER):$(TARGET_PSWD)@$(TARGET_URL)$(value) $(NEW_BRANCH)

clone: ## копировать репозиторий из одного источника в другой
	for repo in $(REPOS) ; do \
	git clone https://gitlab-ci-token:$(TOKEN)@$(SOURCE_URL)$$repo; \
	make gitInit value=$$repo; \
	make remoteAdd value=$$repo; \
	make gitPush value=$$repo; \
	echo "------------------------------------------------------------"; \
   	done
