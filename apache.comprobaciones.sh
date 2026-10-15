#!/bin/bash
# Shell Script para aprender directivas de Apache donde se irán añadiendo paso a paso para que de tiempo a probarlas desde el navegador
# versión 1: comprobaciones con chromium-browser --no-sandbox
# Fernando Barcina - Nov-2018

# Probado en UBUNTU 18.04

user=$(whoami)
if [ "$user" != "root" ]; then
   # Si no es root sale sin ejecutar nada
   echo "No eres root... :'(" 
   exit
fi
# INSTALACIÓN
echo "Hola sr. $user! :) Procedamos con la instalación de LAMP..."
apt update
apt install tree

read -p "Acuérdate de comprobar que el host resuelve: intranet.delarioja.red y www.delarioja.red (Pulsa Enter para Continuar)"

# LLEGA EL MOMENTO DE LAS COMPROBACIONES
    tree /var/www/www.delarioja.red
    read -p "Es momento de navegar todas las posibilidades de https://www.delarioja.red/ no-esta.html blog administrator y ¡puerto 80 en https! y puerto 443 en http (pulsa Enter para Continuar y luego cierra el navegador que se abre)"
	chromium-browser --no-sandbox https://www.delarioja.red/no-esta.html https://www.delarioja.red/blog https://www.delarioja.red/administrator https://www.delarioja.red:80 http://www.delarioja.red:443

    tree /var/www/intranet.delarioja.red
    read -p "Es momento de navegar todas las posibilidades de http://intranet.delarioja.red:8080 no-esta.html: Mostrará un error en base al mensaje; wiki: se verá wiki.html pero si se pone otra página Forbidden porque -Indexes; privada: pedirá validación y mostrará +Indexes porque no encuentra el DirectoryIndex configurado (pulsa Enter para Continuar y luego cierra el navegador que se abre)"
	chromium-browser --no-sandbox http://intranet.delarioja.red:8080/no-esta.html http://intranet.delarioja.red:8080/wiki/wiki.html http://intranet.delarioja.red:8080/privada

    # Probando módulo UserDir
    tree /home/delarioja/public_html
    read -p "Ahora comprueba navegando en http://www.delarioja.red/~delarioja/ (pulsa Enter para Continuar y luego cierra el navegador que se abre)"
    chromium-browser --no-sandbox https://www.delarioja.red/~delarioja http://intranet.delarioja.red:8080/~delarioja

    # Comentamos la desactivación de php para userdir
     sed -i 's/php_admin_flag engine Off/#php_admin_flag engine Off/g' /etc/apache2/mods-available/php7.2.conf
    # Ahora sí debería dejar php a usuarios
	echo "Ejecutando systemctl reload apache2 para permitir php a userdir"; sleep 1
	systemctl reload apache2
	chromium-browser --no-sandbox https://www.delarioja.red/~delarioja http://intranet.delarioja.red:8080/~delarioja
