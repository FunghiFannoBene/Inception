USERNAME := $(shell whoami)
SISTEMA := $(shell uname -s)
ARCHITETTURA := $(shell uname -m)

all: up

pdate-hosts:
    @IP=$(shell ip -f inet addr show | grep -v '127.0.0.1' | grep -Po 'inet \K[\d.]+' | head -n 1) && \
    if ! grep -q "$$IP shhuang.42.fr" /etc/hosts; then \
        echo "$$IP shhuang.42.fr" | sudo tee -a /etc/hosts; \
    else \
        echo "Entry already exists in /etc/hosts"; \
    fi

test:
	@echo "This is a test."

image:
	docker images

remove-unused:
	docker image prune

up:
	@echo "Starting Docker..."
	@systemctl start docker || { echo "Failed to start Docker"; exit 1; }
	@echo "docker systemctl - Exit code: $$?"
	@echo "Starting Docker Compose..."
	@docker-compose -f ./srcs/docker-compose.yml -p inception up -d || { echo "Failed to start Docker Compose"; exit 1; }
	@echo "Docker version:"
	@docker --version || { echo "Failed to get Docker version"; exit 1; }
	@echo "Docker Compose version:"
	@docker-compose --version || { echo "Failed to get Docker Compose version"; exit 1; }
	@echo "DATABASE DISPONIBILE: Local /home/$(USERNAME)/data/WP_DB";
	@echo "WORDPRESS DISPONIBILE: Local /home/$(USERNAME)/data/WORDPRESS";
	@echo "Listing Docker containers..."
	@docker ps || { echo "Failed to list Docker containers"; exit 1; }
	@echo "mariadb IP address:"
	@docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mariadb || { echo "No IP found for mariadb"; exit 1; }
	@echo "wordpress IP address:"
	@docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' wordpress || { echo "No IP found for wordpress"; exit 1; }
	@echo "nginx IP address:"
	@docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nginx || { echo "No IP found for nginx"; exit 1; }
	@echo "Inception pronto: https://$(USERNAME).42.fr"

update:
	@-sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y
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
	@- sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y;
	@-sudo apt install docker.io -y;
	@-sudo apt install curl -y;
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

ip:
	ip a | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*'

network-port:
	docker container inspect nginx --format='{{.NetworkSettings.Ports}}'
	docker exec -it nginx bash -c "ss -tuln"
	docker network inspect Inception_Net
