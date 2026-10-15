#!/bin/bash
# post-instalación: Docker-compose En sistemas Linux, es necesario instalar docker-compose adicionalmente:
sudo curl -L https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker --version
docker-compose --version