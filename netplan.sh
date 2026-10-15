#!/usr/bin/env bash
# Vease también netplan.yaml donde cambia gateway4 por routes
cp /etc/netplan/01-network-manager-all.yaml /etc/netplan/01-network-manager-all.yaml_`date +%d%m%Y_%H%M` # Creamos en primer lugar por seguridad una copia de la configuración actual
ip_mask=$(ip -o -f inet a | awk '/scope global/ {print $4}') # Obtenemos la IP con los bits de la máscara de subred IP/máscara a partir de la información que muestra ip a y lo asignamos a la variable ip_mask
gateway=$(ip -o -4 a list enp0s3 |awk '{print $6}' |cut -d / -f1) # Obtenemos la puerta de enlace a partir de la información que muestra ip a y lo asignamos a la variable gateway

if [[ ! $ip_mask =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/[0-9]{1,2}$ ]]; # Si la variable ip_mask no tiene el formato de ip/máscara, por ejemplo si no tenemos configurada ninguna ip, mostramos un error
then
  echo "No se ha podido obtener la dirección IP actual y su máscara de subred"
else # En caso se haber localizado la ip con su máscara de subred, escribimos sobre el archivo de configuración etc/netplan/01-network-manager-all.yaml indicando la ip y máscara obtenidas y puerta de enlace
  echo "network:
      version: 2
      renderer: networkd
      ethernets:
          $interfaz:
              dhcp4: no
              addresses:
                  - $ip_mask
              gateway4: $gateway" > /etc/netplan/01-network-manager-all.yaml
  sudo netplan apply # aplicamos cambios
  echo "Configuración establecida: " # Mostramos la información de la configuración realizada en el archivo
  cat /etc/netplan/01-network-manager-all.yaml
fi
