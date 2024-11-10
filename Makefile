#!make

.PHONY: help \
		up \
		stop \
		rm \
		rmv \
		rmi \
		logs \
		bash

# --- Application virtual environment settings
DEFAULT_ENV_FILE_NAME ?= .env
DEFAULT_ENV_FILE_PATH := ./$(DEFAULT_ENV_FILE_NAME)

# --- Docker
COMPOSE_CMD := docker compose --env-file $(DEFAULT_ENV_FILE_PATH)


help: ## Commands
	@echo "Please use 'make <target>' where <target> is one of:"
	@awk -F ':|##' '/^[a-zA-Z\-_0-9]+:/ && !/^[ \t]*all:/ { printf "\t\033[36m%-30s\033[0m %s\n", $$1, $$3 }' $(MAKEFILE_LIST)


#--Docker
up: ## Run docker containers
	@$(COMPOSE_CMD) up -d

stop: ## Stop docker containers
	@$(COMPOSE_CMD) stop

rm: ## Remove docker containers
	@$(COMPOSE_CMD) down

rmv: ## Stop and remove docker containers with their volumes
	@$(COMPOSE_CMD) down -v

rmi: ## Stop and remove docker containers with their images and volumes
	@$(COMPOSE_CMD) down --rmi all -v

logs: up ## Stdout logs from docker containers
	@$(COMPOSE_CMD) logs -f

bash: up ## Run the command line in the selected SERVICE docker container
	@docker exec -it $(firstword $(filter-out $@,$(MAKEOVERRIDES) $(MAKECMDGOALS))) bash
