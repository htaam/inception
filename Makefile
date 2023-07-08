NAME = inception
SHELL = /bin/bash
COMPOSE = ./srcs/docker-compose.yml
USER = tmatias

inception:all

all: env up

env:
		@if [ ! -f srcs/.env ] ; then read -p "Env file path: " ENV_FILE;\
			if [ -a $$ENV_FILE ]; then\
				cp $$ENV_FILE srcs/.env;\
			else\
				echo "wrong env file path";\
				exit 42;\
			fi;\
		fi;\

		@mkdir -p /home/$(USER)/data/wordpress/
		@mkdir -p /home/$(USER)/data/mysql/

up: 
	@sudo docker compose -f $(COMPOSE) up -d --build


down:
	@if [ -f srcs/.env ]; then\
		sudo docker compose -f ./srcs/docker-compose.yml down;\
	fi;

clean: down
	@sudo docker system prune -fa
	@sudo rm -rf /home/$(USER)/data/*
	@sudo docker volume rm $$(sudo docker volume ls -q);
	@sudo rm -rf test

fclean: clean
	@sudo rm -rf srcs/.env

re:fclean all

.PHONY: all down up clean fclean re env
	