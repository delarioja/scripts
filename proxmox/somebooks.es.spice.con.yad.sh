#!/bin/bash
# http://somebooks.es/conectar-al-escritorio-una-maquina-virtual-proxmox-ve-sin-la-interfaz-grafica-usando-tickets/
sudo apt install yad curl
# needs pve-manager >= 3.1-44
rm spiceproxy

res=$(yad --width=400 --center --title="" --text="Virtual Desktop Infraestructure" \
--image=dialog-password \
--form \
--field="Usuario" \
--field="Contraseña":H \
--field="VMID")

ret=$?
if [ $ret -eq 0 ]
then
	USERNAME=$(echo $res | cut -d'|' -f1)
	PASSWORD=$(echo $res | cut -d'|' -f2)
	VMID=$(echo $res | cut -d'|' -f3)

	USERNAME="$USERNAME@pve"

	NODE=vs
	PROXY=192.168.2.12

	DATA=`curl -k -d "username=$USERNAME&password=$PASSWORD"  https://$PROXY:8006/api2/json/access/ticket`

	TICKET=`echo $DATA|sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"// g'|grep -w ticket|  awk -F "|" '{print $2}'`

	CSRF=`echo $DATA|sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"// g'|grep -w CSRFPreventionToken| awk -F "|" '{print $2}'`

	curl -k -b "PVEAuthCookie=$TICKET" -H "CSRFPreventionToken: $CSRF" https://$PROXY:8006/api2/spiceconfig/nodes/$NODE/qemu/$VMID/spiceproxy -d "proxy=$PROXY" > spiceproxy

	remote-viewer spiceproxy --full-screen
fi
