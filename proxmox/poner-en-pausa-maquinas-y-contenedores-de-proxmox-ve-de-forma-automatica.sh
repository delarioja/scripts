#!/bin/bash
# Script para poner en pausa todas las máquinas y contenedores, salvo los contenidos en el archivo nopausar.txt
#http://somebooks.es/poner-en-pausa-maquinas-y-contenedores-de-proxmox-ve-de-forma-automatica/
#crontab -e -> 30 20 * * * /scripts/pausar.sh
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

#Cargamos el contenido del archivo 'nopausar.txt' en el array 'nopausar'
readarray nopausar < /scripts/datos/nopausar.txt

#Creamos el archivo 'runing1.txt' con el ID de las máquinas que están corriendo
qm list | grep running | sed 's:  ::g' | cut -d ' ' -f2 > "/scripts/datos/runing1.txt"

#Leemos línea a línea el archivo 'runing1.txt' y guardamos su valor en la variable ID
while read -r ID
do
  accion="pausar"
  #Si encontramos el ID en el array 'nopausar' cambiamos el valor de la variable 'accion'
  case "${nopausar[@]}" in  *"$ID"*) accion="no pausar" ;; esac

  #Si la 'accion' sigue siendo 'pausar', suspendemos la máquina virtual
  if [[ $accion == "pausar" ]]
  then
    qm suspend $ID
  fi
done < "/scripts/datos/runing1.txt"

#Ahora repetimos el proceso con los contenedores

pct list | grep running | cut -d ' ' -f1 > "/scripts/datos/runing2.txt"

while read -r ID
do
  accion="pausar"
  case "${nopausar[@]}" in  *"$ID"*) accion="no pausar" ;; esac

  if [[ $accion == "pausar" ]]
  then
    pct suspend $ID
  fi
done < "/scripts/datos/runing2.txt"

#Por último, hacemos limpieza
rm /scripts/datos/runing1.txt
rm /scripts/datos/runing2.txt
unset accion ID
