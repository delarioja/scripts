#!/bin/bash
# Shell Script para aprender directivas de Apache donde se irán añadiendo paso a paso para que de tiempo a probarlas desde el navegador
# versión 1: comprobaciones con chromium-browser --no-sandbox
# Fernando Barcina - Nov-2019
# Probado en UBUNTU 18.04 Desktop
user=$(whoami)
if [ "$user" = "root" ]; then
   # Si no es root sale sin ejecutar nada
   echo "No lo ejecutes como root sino como el usuario que ha iniciado la sesión, necesito cargar el navegador :'(" 
   exit 1
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
read -p "Pulsa Enter para Continuar"
if (whiptail --title "Escribo en el fichero hosts?" --yes-button "Aceptar" --no-button "Cancelar" --yesno "¿Modifico /etc/hosts?" 8 78) then
	CADENA=$(whiptail --title "Línea a añadir a /etc/hosts" --inputbox "Qué línea añado a /etc/hosts?" 10 60 "192.168.1.100 intranet.delarioja.red www.delarioja.red" 3>&1 1>&2 2>&3)
	echo $CADENA | sudo tee -a /etc/hosts > /dev/null
fi
# LLEGA EL MOMENTO DE LAS COMPROBACIONES
read -p "Es momento de navegar todas las posibilidades de https://www.delarioja.red/ no-esta.html blog administrator y ¡puerto 80 y 443 en https! (pulsa Enter para Continuar y luego cierra el navegador que se abre)"
chromium-browser https://www.delarioja.red/no-esta.html https://www.delarioja.red/blog https://www.delarioja.red/administrator https://www.delarioja.red:443
