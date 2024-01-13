USERNAME := $(shell whoami)

all: install up

up:
	docker-compose -f ./srcs/docker-compose.yml up -d

update:
	sudo apt update
	yes | sudo apt install docker.io
	sudo usermod -aG docker $(USERNAME)
	sudo chown "$(USERNAME)":"$(USERNAME)" /var/run/docker.sock
	yes | sudo apt install docker-compose
	sleep 2
	clear
	docker --version
	docker-compose --version

down:
	docker-compose -f ./srcs/docker-compose.yml down

stop:
	docker-compose -f ./srcs/docker-compose.yml stop

start:
	docker-compose -f ./srcs/docker-compose.yml start

status:
	docker ps
