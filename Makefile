#!make

ifneq (,$(wildcard ./.env))
    include .env
    export
else
$(error No se encuentra el fichero .env)
endif

help: _header
	${info }
	@echo Opciones:
	@echo ---------------------------------
	@echo start / start-no-external-network
	@echo stop / restart
	@echo ---------------------------------
	@echo stats / logs / workspace
	@echo clean
	@echo ---------------------------------

_header:
	@echo ---------------
	@echo MariaDB + Vault
	@echo ---------------

_urls: _header
	${info }
	@echo ----------------------------------
	@echo [phpMyAdmin] http://localhost:8080
	@echo ----------------------------------

_start-command:
	@docker compose up -d --remove-orphans

start-no-external-network: _header _start-command _urls

_start-command-network:
	@docker compose -f docker-compose.yml -f docker-compose.network.yml up -d --remove-orphans

start: _header _start-command-network _urls

stop:
	@docker compose stop

restart: stop start

stats:
	@docker stats

logs:
	@docker compose logs mariadb

workspace:
	@docker compose exec mariadb /bin/bash

clean:
	@docker compose down -v --remove-orphans
