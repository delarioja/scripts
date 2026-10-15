#!/bin/bash
#ejecutar como root sino buscar alternativa con expect: apt install expect; expect https://delarioja.org/scripts/ubuntudesktop.exp
if [ "$(id -u)" != "0" ]; then
	# Muestra un mensaje en consola al usuario actual cuando no es root
	echo "Ejecuta este script como root (o usando sudo)."
	# Termina el script con un codigo 1
	# Normalmente en bash cuando un programa retorna algo diferente a 0 significa que genera un error
	exit 1
fi
echo 'export HISTTIMEFORMAT="%F %T "' >> /etc/skel/.bashrc 
echo 'export HISTTIMEFORMAT="%F %T "' >> /root/.bashrc
echo 'export HISTTIMEFORMAT="%F %T "' >> /home/delarioja/.bashrc

#mostrar tambien fecha en gnome
#dconf write /org/gnome/desktop/interface/clock-show-date 'true'
#habria que cambiar tambien dconf write para usuario delarioja
#quitamos el bloqueo de pantalla segura
#lo siguiente en ubuntu 20.04 no funciona
#gsettings set org.gnome.desktop.screensaver lock-enabled false
sudo dpkg-reconfigure unattended-upgrades
sudo apt update && sudo apt -y dist-upgrade
sudo apt install dkms linux-headers-$(uname -r)
sudo apt install terminator
sudo apt install python3-pip python3-requests
mkdir -p /home/delarioja/.config/terminator/plugins
wget https://git.io/v5Zww -O "/home/delarioja/.config/terminator/plugins/terminator-themes.py"
wget https://delarioja.org/scripts/config -O "/home/delarioja/.config/terminator/config"

#Revisar actualizaciones cada 2 días, quitar actualizaciones automaticas y autoclean cada 7 días
cat > /etc/apt/apt.conf.d/20auto-upgrades <<'EOF'
APT::Periodic::Update-Package-Lists "2";
APT::Periodic::Download-Upgradeable-Packages "0";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "0";
EOF
cat > /etc/apt/apt.conf.d/10periodic <<'EOF'
APT::Periodic::Update-Package-Lists "2";
APT::Periodic::Download-Upgradeable-Packages "0";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "0";
EOF
sudo apt autoremove

