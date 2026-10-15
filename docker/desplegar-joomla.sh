#!/bin/bash
docker network create joomla-network
docker pull mariadb:latest
docker pull joomla:latest
docker images
docker volume create mariadb_datos
docker volume create joomla_datos
docker volume inspect mariadb_datos
docker volume inspect joomla_datos

docker run --rm -d --name mariadb \
    -e MYSQL_ROOT_PASSWORD=org \
    -e MYSQL_DATABASE=joomla \
    -e MYSQL_USER=joomlauser \
    -e MYSQL_PASSWORD=org \
    --network joomla-network \
    -v mariadb_datos:/var/lib/mysql \
    mariadb:lts

docker run --rm -d --name joomla \
    -p 8088:80 \
    -e JOOMLA_DB_HOST=mariadb \
    -e JOOMLA_DB_USER=joomlauser \
    -e JOOMLA_DB_PASSWORD=org \
    -e JOOMLA_DB_NAME=joomla \
    --network joomla-network \
    -v joomla_datos:/var/www/html \
    joomla:php8.3-apache

#docker ps
#http://localhost:8088
