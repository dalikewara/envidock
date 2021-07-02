# Load .env if it exists
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

# Print info
info:
	@echo "\n\
	===============================================================================\n\
	HELLO THERE,\n\n\
	This application required environment variables listed in \".env.example\".\n\
	For development & testing, you can make a copy of \".env.example\" and \n\
	name it to \".env\". For production use, you may not use \".env\" file and\n\
	set all the required variables in different way manually into the system.\n\
	\nAVAILABLE COMMANDS\n"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo "\nAVAILABLE OPTIONS\n\n\
	on : Affect only to specified service on commands: \`build\`, \`up\`, \`stop\`, \`start\` & \`restart\`\n\
	     Example: \`make build on=mysql\` will build & run only MySQL environment service\n\
	===============================================================================\n"

build: up ## Build all environment services

destroy: down clear-mongo clear-mysql clear-postgres clear-redis clear-rabbitmq ## Destroy all environment services. This will also clear all volumes & data

up: ## Create & run all environment services
	@docker-compose up -d ${on}

down: ## Remove all environment services, but leave all volumes & data untouched
	@docker-compose down

stop: ## Stop all environment services
	@docker-compose stop ${on}

start: ## Start all environment services
	@docker-compose start ${on}

restart: ## Restart all environment services
	@docker-compose restart ${on}

clear-mongo: ## Clear Mongo volume & data
	@docker volume rm envidock_mongo-data

clear-mysql: ## Clear MySQL volume & data
	@docker volume rm envidock_mysql-data

clear-postgres: ## Clear Postgres volume & data
	@docker volume rm envidock_mysql-data

clear-redis: ## Clear Redis volume & data
	@docker volume rm envidock_redis-data

clear-rabbitmq: ## Clear RabbitMQ volume & data
	@docker volume rm envidock_rabbitmq-data
