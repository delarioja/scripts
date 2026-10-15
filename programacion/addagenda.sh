#!/bin/bash
for (( ; ; )); # Realizamos un bucle infinito del cual solo se saldrá cuando se cumpla la condición del if (nombre = FIN)
  do
    echo "Introduce los datos del contacto a guardar: "

    read -p "Ingresa un nombre: " -a nombre # Solicitamos el nombre y lo guardamos en la variable nombre
    if [ "$nombre" = "FIN" ] # Si el valor introducido como nombre es FIN salimos del bucle
    then
      break
    fi
    read -p "Ingresa la dirección de $nombre: " -a dir # Solicitamos la dirección y lo almacenamos en la variable direccion
    read -p "Ingresa el teléfono de $nombre : " -a tlf # Solicitamos el teléfono y lo guardamos en la variable tlf

    echo "$nombre $dir $tlf" | column -t >> agenda.txt # Introducimos los datos almacenados en la variable separados por : en el archivo agenda.txt
    #echo "$nombre:$dir:$tlf" >> agenda.txt # Introducimos los datos almacenados en la variable separados por : en el archivo agenda.txt
  done
