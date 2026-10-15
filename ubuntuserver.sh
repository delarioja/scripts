#!/bin/bash
#ejecutar como root sino buscar alternativa con expect: apt install expect; expect https://delarioja.org/scripts/ubuntuserver.exp
if [ "$(id -u)" != "0" ]; then
	# Muestra un mensaje en consola al usuario actual cuando no es root
	echo "Ejecuta este script como root (o usando sudo)."
	# Termina el script con un código 1
	# Normalmente en bash cuando un programa retorna algo diferente a 0
	# significa que generó un error
	exit 1
# Fin del if
fi
echo 'export HISTTIMEFORMAT="%F %T "' >> /home/delarioja/.bashrc
echo 'export HISTTIMEFORMAT="%F %T "' >> /etc/skel/.bashrc 
echo 'export HISTTIMEFORMAT="%F %T "' >> /root/.bashrc
sudo sed -i 's/Unattended-Upgrade \"1\"/Unattended-Upgrade \"0\"/g' /etc/apt/apt.conf.d/20auto-upgrades
sudo dpkg-reconfigure unattended-upgrades
sudo apt update && sudo apt -y dist-upgrade
sudo -u delarioja wget https://delarioja.org/scripts/instalar-guest-additions.sh
bash instalar-guest-additions.sh


