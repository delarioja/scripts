#!/bin/bash

# 4.Script que a partir de la IP, máscara y puerta de enlace por defecto actuales que permiten
# salir a Internet a la máquina, configure un yaml en /etc/netplan para que se incluya esta
# información como estática y aplique dicha configuración.

function indice(){
# FUNCIÓN INDICE DEL SCRIPT
# Uso del date para crear backup del fichero
# cp /etc/netplan/01-network-manager-all.yaml /etc/netplan/01-network-manager-all.yaml.bk_`date +%Y%m%d%H%M`
  seleccionar
# Indicamos al usuario que ha terminado la configuración
  echo
  barra
  echo -e "\e[1;34mSigamos con la configuración :)\e[0m"
  barra
  echo

  confignet

  echo
  barra
  echo -e "\e[1;34mLa configuración del netplan a sido existosa :)\e[0m"
  echo -e "\e[1;34mYa hemos terminado de configurar tu tarjeta :)\e[0m"
  barra
  echo
  echo
  echo -e "\e[1;34mDeseas configurar otra tarjeta más? :)\e[0m"
  YesNo
  case $? in
    0 ) indice
      ;;
    1 ) return
      ;;
  esac
  unset -f YesNo
}

function seleccionar(){
# FUNCIÓN PARA MOSTRAR Y SELECCIONAR TARJETAS
  echo -e "\e[1;34m=============================================\e[0m"
  echo -e "\e[1;34m¿Que tarjeta quieres modificar?"
  echo -e "\e[1;34m=============================================\e[0m"
# Creación de archivo temporal para la recogida de tarjetas
  netstat -i | grep -v 'lo\|Iface\|Tabla' | awk '{print $1}' > nic.tmp 
# Declaración de variables (en bash todas las variables son globales)
# Algnas variables locales que solo existen dentro de la función
  nicnum=$(netstat -i | grep -v 'lo\|Iface\|Tabla' | awk '{print $1}' | wc -l)
  local cont=1    
  local nic=(`cat "nic.tmp"`)
# Bucle de listado de tarjetas
  for i in "${nic[@]}";
  do                  
  echo -e " " "\e[1;34m$cont.-\e[0m" "\e[0;32m$i\e[0m"
  ((cont++))  
  done
# Recoger la respuesta sobre las tarjetas
  echo -e "\e[1;34m============>\e[0m\c"; read -p "" ans
# Leer la respuesta para saber si esta en el rango
# Si el valor ingresado genera error (carácter alfanumérico), es deviado a /dev/null
# ----------------------------------------------------------------------------------
  if [ "$ans" -ge 0 ] && [ "$ans" -le "$nicnum" ]; then
    nicfinal=${nic[(($ans-1))]} 
    echo -e "\e[0;36mHas elegido la tarjeta: \e[0m" "\e[1;36m$nicfinal\e[0m"
    YesNo
    case $? in
      0 ) return
        ;;
      1 ) seleccionar
        ;;
    esac
    unset -f YesNo
  else
    echo -e "\e[0;36mEsa tarjeta no existe, vuelva a elegir una de la lista: \e[0m"
    seleccionar
  fi
}

function confignet(){
# FUNCIÓN DE CONFIGURACION DE FICHERO NETPLAN
# Preguntar por la configuración de la red
  echo -e "\e[1;34mInserta la IP que quieres asignarle a tu tarjeta: \e[0m\c"; read -p "" staticip 
  echo -e "\e[1;34mY el número de bits de red para la misma: \e[0m\c"; read -p "" net
  echo -e "\e[1;34mInserta la dirección de la puerta de enlace: \e[0m\c"; read -p "" gateway
  echo -e "\e[1;34mInserta los servidores dns de confianza separados por comilla y espacio ', ': \e[0m\c"; read -p "" dns
  echo
# Preguntar si desea dicha configuración
  barra
  echo -e "\e[0;36mIp ==>$staticip\e[0m"
  echo -e "\e[0;36mMáscara ==>$net\e[0m"
  echo -e "\e[0;36mPuerta de enlace ==>$gateway\e[0m"
  echo -e "\e[0;36mServidores dns ==>$dns\e[0m"
  barra
  echo
  echo -e "\e[1;34m¿Deseas aplicar esta configuración?\e[0m"
  YesNo
  case $? in
    0 ) escribir
      ;;
    1 ) confignet
      ;;
  esac
  unset -f YesNo
}

function escribir(){
# Esta comentado porque no me funciona lo que te he dicho y salta a la funcion indice
# Buscar en el fichero coincidencias de otra configuración anterior y eliminarlo

# ESTE ES EL BUCLE CON EL QUE TENGO DUDAS FERNANDO

# eqNICline es una variable que me recoge el numero de la linea en el que se situa en el netplan la tarjeta que tengo elegida
  eqNICline=$(grep -n $nicfinal /etc/netplan/01-network-manager-all.yaml | awk '{print $1}' | cut -b1)
# y simplemente le sumo 5 a la linea que empieza la configuracion de la tarjeta porque asi recojo en un bucle todas las lineas de la 
# configuracion que le corresponden a la tarjeta que simplemente son 5 lineas
  lineastotal=$(($eqNICline+5))
# Aqui creo una copia del fichero original sin cambios, antes lo tenia dentro y estoy dudando si deberia de ir dentro o fuera con el bucle
  sudo cp /etc/netplan/01-network-manager-all.yaml /etc/netplan/01-network-manager-all-grep.yaml
# Empieza el bucle
  until [[ $eqNICline -eq $lineastotal ]]; do
# Con sed voy recogiendo el numero de la linea que quiero substraer (empieza con el nombre de la tarjeta) y lo guardo todo en un archivo -ok-.
    sed "($eqNICline)d" /etc/netplan/01-network-manager-all.yaml > /etc/netplan/01-network-manager-all-ok.yaml
# Y con grep recojo la copia del fichero original y con el -ok- creado que deberia de contener la configuracion de una tarjeta busco todo lo que
# coincida en la copia del fichero original de forma invertida (grep -v) entonces deberia de obtener la salida de todo el contenido menos la parte 
# de la tarjeta seleccionada. El grep -f es simplemente para pasarle un fichero al grep como patron de busqueda linea por linea
    grep -v -f /etc/netplan/01-network-manager-all-ok.yaml /etc/netplan/01-network-manager-all-grep.yaml > /etc/netplan/01-network-manager-all-ok.yaml
# Una vez redirigido todo lo que queria, que es el fichero original sin la config de la tarjeta elegida para mas adelante meterle una config nueva,
# escribo la salida del grep en el fichero -ok- porque ya me da igual su contenido
    sudo mv /etc/netplan/01-network-manager-all-ok.yaml /etc/netplan/01-network-manager-all.yaml
# le cambio el nombre de nuevo para seguir trabajando con el nombre original pero no funciona
    ((eqNICline++)) # Este contador es para pasar por todas las lineas, *mirar condicion del until*
  done


# Introducir la configuración en el fichero netplan
  cat >> /etc/netplan/01-network-manager-all.yaml <<EOF
    $nicfinal:
      addresses:
        - $staticip/$net
      gateway4: $gateway
      nameservers:
        addresses: [$dns]
EOF

  sudo netplan apply
}

function YesNo(){
# FUNCIÓN PARA DECIDIR SI O NO EN UNA PREGUNTA
  echo -e "\e[1;34m¿Que quieres hacer?(Si/No)\e[0m\c"; read -p "" confirm
  if [[ "$confirm" == "Si" || "$confirm" == "S" || "$confirm" == "s" ||  "$confirm" == "si" ]]; then
    return 0
  elif [[ "$confirm" == "No" || "$confirm" == "N" || "$confirm" == "n" || "$confirm" == "no"  ]]; then
    return 1
  else
    "Porfavor escriba (S/Si) o (N/No)"
    YesNo
  fi 
}

function barra(){
# FUNCIÓN PARA IMPRIMIR BARRAS (=====)
  echo -e "\e[1;34m===========================\e[0m"
}

# EMPIEZA EL SCRIPT
# Limpiamos terminal de comandos ejecutados anteriormente.
clear
# Comprobamos que el fichero Bash ha sido ejecutado como SuperUsuario - root.
# En caso FALSE informamos al usuario de que ejecute de nuevo como root.
# En caso TRUE se llama a la función Confignet.
if [ "$(id -u)" != "0" ]; then
  echo
  echo "============================================================================"
  echo "¡Este Script debe ejecutarse como SuperUsuario!"
  echo "============================================================================"
  echo
  exit 1
else
# Llamada a la función main que actua como indice del script
  indice
  exit 1
fi

# FALTA 
# Funcion para poder elegir distintos ficheros yaml si no se llama igual al ejemplo
# Si el netplan da error volver a pedir configuración
# Poner dhcp o no