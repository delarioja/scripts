#!/bin/bash
# Shell Script para aprender directivas de Apache donde se irán añadiendo paso a paso para que de tiempo a probarlas desde el navegador
# versión 2: comprobaciones con chromium-browser
# Fernando Barcina - Nov-2020
# Probado en UBUNTU 20.04 Desktop
user=$(whoami)
if [ "$user" = "root" ]; then
   # Si no es root sale sin ejecutar nada
   echo "No lo ejecutes como root sino como el usuario que ha iniciado la sesión :'(" 
   exit 1
fi
if test $(dpkg --get-selections |grep "^tree"|wc -l) -eq 0
then
	sudo apt update
	sudo apt install tree
fi
if test $(dpkg --get-selections |grep "^chromium-browser"|wc -l) -eq 0
then
    sudo apt update
    sudo apt install chromium-browser
fi
IP_SERVIDOR=$(whiptail --title "IP del servidor Apache" --inputbox "Cual es la IP del servidor Apache?" 10 60 "192.168.1.100" 3>&1 1>&2 2>&3)
read -p "Comprobando que este host cliente resuelve: intranet.delarioja.red y www.delarioja.red (Pulsa Enter para Continuar)"
ping -c3 intranet.delarioja.red
ping -c3 www.delarioja.red
if (whiptail --title "Escribo en el fichero hosts?" --yes-button "Aceptar" --no-button "Cancelar" --yesno "¿Modifico /etc/hosts?" 8 78) then
	CADENA=$(whiptail --title "Línea a añadir a /etc/hosts" --inputbox "Qué línea añado a /etc/hosts?" 10 60 "192.168.1.100 intranet.delarioja.red www.delarioja.red" 3>&1 1>&2 2>&3)
	echo $CADENA | sudo tee -a /etc/hosts > /dev/null
	# o también habría valido: sh -c "$CADENA" >> /etc/hosts"
else
    echo "Has seleccionado No, el if toma el valor de $? y continuo con el script"
fi
# LLEGA EL MOMENTO DE LAS COMPROBACIONES
# configurar un ssh por certificado para hacer: tree /var/www/intranet.delarioja.red
read -p "Es momento de navegar todas las posibilidades de http://intranet.delarioja.red:8080/no-esta.html: Mostrará un error en base al mensaje; wiki: se verá wiki.html pero si se pone otra página Forbidden porque -Indexes; privada: mostrará +Indexes porque no encuentra el DirectoryIndex configurado (pulsa Enter para Continuar y luego cierra el navegador que se abre)"
chromium-browser http://intranet.delarioja.red:8080/wiki/wiki.html http://intranet.delarioja.red:8080/wiki/wiki-noesta.html http://intranet.delarioja.red:8080/privada http://intranet.delarioja.red:8080/no-esta.html
