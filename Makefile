USERNAME := $(shell whoami)
SISTEMA := $(shell uname -s)
ARCHITETTURA := $(shell uname -m)

all: update up

up:
	@sudo systemctl start docker
	@docker-compose -f ./srcs/docker-compose.yml up -d
	@docker --version;
	@docker-compose --version;
	@echo "DATABASE DISPONIBILE: Local /home/$(USERNAME)/data/WP_DB";
	@echo "WORDPRESS DISPONIBILE: Local /home/$(USERNAME)/data/WORDPRESS";
	@docker ps
	@echo mariadb:
	@docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mariadb
	@echo wordpress:
	@docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' wordpress
	sleep 2;
update:
	@-sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
	@if [ ! -f ./srcs/.env ]; then \
            touch ./srcs/.env; \
            echo "MYSQL_ROOT_PASSWORD=your_password" >> ./srcs/.env; \
            echo "MYSQL_DATABASE=wordpress" >> ./srcs/.env; \
            echo "MYSQL_USER=wp_user" >> ./srcs/.env; \
            echo "MYSQL_PASSWORD=wp_password" >> ./srcs/.env; \
            echo "WORDPRESS_DB_HOST=db:3306" >> ./srcs/.env; \
            echo "WORDPRESS_DB_USER=wp_user" >> ./srcs/.env; \
            echo "WORDPRESS_DB_PASSWORD=wp_password" >> ./srcs/.env; \
            echo "WORDPRESS_DB_NAME=wordpress" >> ./srcs/.env; \
        fi
	@-yes | sudo apt update && yes | sudo apt upgrade && yes | sudo apt autoremove;
	@sudo systemctl restart lightdm.service
	@-yes | sudo apt install docker.io;
	@-yes | sudo apt install curl;
	@bash -c 'until sudo curl -Lf "https://github.com/docker/compose/releases/latest/download/docker-compose-$(SISTEMA)-$(ARCHITETTURA)" -o /usr/local/bin/docker-compose; do sleep 5; done; sudo chmod +x /usr/local/bin/docker-compose;'
	@sudo chmod +x /usr/local/bin/docker-compose;
	@-sudo usermod -aG docker $(USERNAME);
	@-sudo chown "$(USERNAME)":"$(USERNAME)" /var/run/docker.sock
	@-mkdir -p /home/$(USERNAME)/data/WP_DB;
	@-mkdir -p /home/$(USERNAME)/data/WORDPRESS;
	#@-sudo chown -R mysql:mysql /home/$(USERNAME)/data/WP_DB;
	@-sudo chmod -R 755 /home/$(USERNAME)/data/WP_DB;

down:
	docker-compose -f ./srcs/docker-compose.yml down

stop:
	docker-compose -f ./srcs/docker-compose.yml stop

start:
	docker-compose -f ./srcs/docker-compose.yml start

status:
	docker ps -a

GIGAREMOVE_YES: remove
	@echo "ATTENZIONE: SEI SICURO DI VOLER RIMUOVERE FILE CUSTOM? (yes/any)"
	@read dichiarazione; \
	if [ "$$dichiarazione" = "yes" ]; then \
		sudo rm -rf /etc/docker /home/$(USERNAME)/data/WORDPRESS /home/$(USERNAME)/data/WP_DB; \
		echo "File rimossi."; \
	else \
		echo "Cancellazione rifiutata, digitare \"yes\" se si desidera rimuovere."; \
	fi
remove:
	-@if [ $$(docker ps -q | wc -l) -gt 0 ]; then \
		docker stop $$(docker ps -q); \
	fi
	-@if [ $$(docker ps -aq | wc -l) -gt 0 ]; then \
		docker rm $$(docker ps -aq); \
	fi
	-@if [ $$(docker images -q | wc -l) -gt 0 ]; then \
		docker rmi -f $$(docker images -q); \
	fi
	-sudo systemctl stop docker;
	-yes | sudo apt-get remove --purge docker docker.io && yes | sudo apt autoremove;
	-sudo rm -rf /usr/local/bin/docker-compose;
	-sudo usermod -aG docker $(USERNAME);

ip:
	ip a | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*'

network-port:
	docker container inspect nginx --format='{{.NetworkSettings.Ports}}'
	docker exec -it nginx bash -c "ss -tuln"
	docker network inspect Inception_Net

