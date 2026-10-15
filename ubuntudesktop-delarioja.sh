#!/bin/bash
#ejecutar como root sino buscar alternativa con expect: apt install expect; expect https://delarioja.org/scripts/ubuntudesktop.exp
if [ "$(id -u)" != "1000" ]; then
	# Muestra un mensaje en consola al usuario actual cuando no es root
	echo "Ejecuta este script como usuario delarioja uid=1000"
	# Termina el script con un codigo 1
	# Normalmente en bash cuando un programa retorna algo diferente a 0 significa que genera un error
	exit 1
fi
echo 'export HISTTIMEFORMAT="%F %T "' >> /home/delarioja/.bashrc
#mostrar tambien fecha en gnome
dconf write /org/gnome/desktop/interface/clock-show-date 'true'
