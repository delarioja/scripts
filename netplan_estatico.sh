#!/bin/bash

# 1. COMPROBACIÓN DE PRIVILEGIOS
# Modificar la red requiere permisos de superusuario
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, ejecuta este script como root (usando sudo)."
  exit 1
fi

echo "--- CONFIGURADOR DE NETPLAN ESTÁTICO ---"

# 2. OBTENCIÓN DE DATOS DE LA RED ACTUAL
# Averiguamos la interfaz principal buscando la ruta por defecto
INTERFAZ=$(ip route show default | awk '/default/ {print $5}')
# Averiguamos la puerta de enlace (Gateway)
GATEWAY=$(ip route show default | awk '/default/ {print $3}')
# Averiguamos la IP y la máscara (en formato CIDR, ej. 192.168.1.10/24) de esa interfaz
IP_CIDR=$(ip -4 addr show "$INTERFAZ" | grep -oP '(?<=inet\s)\d+(\.\d+){3}/\d+')

echo "Datos detectados automáticamente:"
echo "- Interfaz: $INTERFAZ"
echo "- IP/Máscara: $IP_CIDR"
echo "- Puerta de enlace: $GATEWAY"

read -p "¿Deseas aplicar esta configuración como estática? (s/n): " CONFIRMAR
if [ "$CONFIRMAR" != "s" ]; then
    echo "Operación cancelada."
    exit 0
fi

# 3. CREACIÓN DEL ARCHIVO YAML
ARCHIVO_YAML="/etc/netplan/99-config-estatica.yaml"

# Usamos un Heredoc (<<EOF) para escribir múltiples líneas en el archivo cómodamente 
cat <<EOF > "$ARCHIVO_YAML"
network:
  version: 2
  renderer: networkd
  ethernets:
    $INTERFAZ:
      dhcp4: no
      addresses:
        - $IP_CIDR
      routes:
        - to: default
          via: $GATEWAY
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
EOF

echo "Archivo $ARCHIVO_YAML generado correctamente."

# 4. APLICAR CAMBIOS
echo "Aplicando configuración con netplan..."
netplan apply

echo "¡Red configurada estáticamente!"