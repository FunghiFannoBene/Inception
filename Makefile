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
	@echo nginx:
	@docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nginx
	@echo wordpress:
	@docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' wordpress

update:
	@-yes | sudo apt update && yes | sudo apt upgrade && yes | sudo apt autoremove;
	@-yes | sudo apt install docker.io;
	@-yes | sudo apt install docker;
	@-yes | sudo apt install curl;
	@bash -c 'until sudo curl -Lf "https://github.com/docker/compose/releases/latest/download/docker-compose-$(SISTEMA)-$(ARCHITETTURA)" -o /usr/local/bin/docker-compose; do sleep 5; done; sudo chmod +x /usr/local/bin/docker-compose;'
	@sudo chmod +x /usr/local/bin/docker-compose;
	@-sudo usermod -aG docker $(USERNAME);
	@-sudo chown "$(USERNAME)":"$(USERNAME)" /var/run/docker.sock
	@-sudo systemctl start docker;
	@-mkdir -p /home/$(USERNAME)/data/WP_DB;
	@-mkdir -p /home/$(USERNAME)/data/WORDPRESS;
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
	-sudo usermod -G docker $(USERNAME);

ip:
	~/Desktop/ipssh
