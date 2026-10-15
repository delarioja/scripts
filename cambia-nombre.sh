#!/bin/bash
if [ "$(id -u)" != "0" ]; then
	# Muestra un mensaje en consola al usuario actual cuando no es root
	echo "Ejecuta este script como root (o usando sudo)."
	# Termina el script con un código 1
	# Normalmente en bash cuando un programa retorna algo diferente a 0
	# significa que generó un error
	exit 1
# Fin del if
fi
sed -i 's/127.0.1.1.*/127.0.1.1\t'"$1"'/g' /etc/hosts 
hostnamectl set-hostname $1
